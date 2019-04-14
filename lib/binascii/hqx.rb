# frozen_string_literal: true

module Binascii
  module Hqx
    class DecodeError < ::StandardError
    end

    A2B_TABLE = [
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :skip, :fail, :fail, :skip, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, 0x00,  0x01,  0x02,  0x03,  0x04,  0x05,  0x06,
      0x07,  0x08,  0x09,  0x0A,  0x0B,  0x0C,  :fail, :fail,
      0x0D,  0x0E,  0x0F,  0x10,  0x11,  0x12,  0x13,  :fail,
      0x14,  0x15,  :done, :fail, :fail, :fail, :fail, :fail,
      0x16,  0x17,  0x18,  0x19,  0x1A,  0x1B,  0x1C,  0x1D,
      0x1E,  0x1F,  0x20,  0x21,  0x22,  0x23,  0x24,  :fail,
      0x25,  0x26,  0x27,  0x28,  0x29,  0x2A,  0x2B,  :fail,
      0x2C,  0x2D,  0x2E,  0x2F,  :fail, :fail, :fail, :fail,
      0x30,  0x31,  0x32,  0x33,  0x34,  0x35,  0x36,  :fail,
      0x37,  0x38,  0x39,  0x3A,  0x3B,  0x3C,  :fail, :fail,
      0x3D,  0x3E,  0x3F,  :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail,
      :fail, :fail, :fail, :fail, :fail, :fail, :fail, :fail
    ].freeze

    B2A_TABLE = "!\"#$%&'()*+,-012345689@ABCDEFGHIJKLMNPQRSTUVXYZ[`abcdefhijklmpqr"
      .bytes
      .freeze

    RLE_RUN_CHAR = 0x90

    def a2b_hqx(str)
      result = String.new('', encoding: 'ASCII-8BIT')
      bits = 0
      buffer = 0
      pos = 0
      done = 0

      str.each_byte do |byte|
        ch = A2B_TABLE[byte]

        if ch == :fail
          raise DecodeError, "Illegal character at position #{pos}"
        elsif ch == :done
          done = 1
          break
        end

        buffer = (buffer << 6) | ch
        bits += 6

        if bits >= 8
          bits -= 8
          result << ((buffer >> bits) & 0xFF)
          buffer &= ((1 << bits) - 1)
        end

        pos += 1
      end

      if bits > 0 && done == 0
        raise DecodeError, 'String has incomplete number of bytes'
      end

      [result, done]
    end

    def b2a_hqx(data)
      String.new('', encoding: 'ASCII-8BIT').tap do |result|
        bits = 0
        buffer = 0

        data.each_byte do |byte|
          buffer = (buffer << 8) | byte
          bits += 8

          while bits >= 6
            ch = (buffer >> (bits - 6)) & 0x3F
            result << B2A_TABLE[ch]
            bits -= 6
          end
        end

        if bits > 0
          buffer <<= (6 - bits)
          result << B2A_TABLE[buffer & 0x3F]
        end
      end
    end

    def rlecode_hqx(data)
      String.new('', encoding: 'ASCII-8BIT').tap do |result|
        len = data.bytesize
        pos = 0

        while pos < len
          byte = data.getbyte(pos)

          if byte == RLE_RUN_CHAR
            result << RLE_RUN_CHAR
            result << 0
          else
            count = 0
            (len - pos).times do |i|
              break if data.getbyte(pos + i) != byte
              count += 1
            end

            result << byte

            if count > 3
              result << RLE_RUN_CHAR
              result << count
              pos += count - 1
            end
          end

          pos += 1
        end
      end
    end

    def rledecode_hqx(data)
    end
  end
end
