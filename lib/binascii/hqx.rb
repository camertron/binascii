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

    CRC_TABLE = [
      0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50A5, 0x60C6, 0x70E7,
      0x8108, 0x9129, 0xA14A, 0xB16B, 0xC18C, 0xD1AD, 0xE1CE, 0xF1EF,
      0x1231, 0x0210, 0x3273, 0x2252, 0x52B5, 0x4294, 0x72F7, 0x62D6,
      0x9339, 0x8318, 0xB37B, 0xA35A, 0xD3BD, 0xC39C, 0xF3FF, 0xE3DE,
      0x2462, 0x3443, 0x0420, 0x1401, 0x64E6, 0x74C7, 0x44A4, 0x5485,
      0xA56A, 0xB54B, 0x8528, 0x9509, 0xE5EE, 0xF5CF, 0xC5AC, 0xD58D,
      0x3653, 0x2672, 0x1611, 0x0630, 0x76D7, 0x66F6, 0x5695, 0x46B4,
      0xB75B, 0xA77A, 0x9719, 0x8738, 0xF7DF, 0xE7FE, 0xD79D, 0xC7BC,
      0x48C4, 0x58E5, 0x6886, 0x78A7, 0x0840, 0x1861, 0x2802, 0x3823,
      0xC9CC, 0xD9ED, 0xE98E, 0xF9AF, 0x8948, 0x9969, 0xA90A, 0xB92B,
      0x5AF5, 0x4AD4, 0x7AB7, 0x6A96, 0x1A71, 0x0A50, 0x3A33, 0x2A12,
      0xDBFD, 0xCBDC, 0xFBBF, 0xEB9E, 0x9B79, 0x8B58, 0xBB3B, 0xAB1A,
      0x6CA6, 0x7C87, 0x4CE4, 0x5CC5, 0x2C22, 0x3C03, 0x0C60, 0x1C41,
      0xEDAE, 0xFD8F, 0xCDEC, 0xDDCD, 0xAD2A, 0xBD0B, 0x8D68, 0x9D49,
      0x7E97, 0x6EB6, 0x5ED5, 0x4EF4, 0x3E13, 0x2E32, 0x1E51, 0x0E70,
      0xFF9F, 0xEFBE, 0xDFDD, 0xCFFC, 0xBF1B, 0xAF3A, 0x9F59, 0x8F78,
      0x9188, 0x81A9, 0xB1CA, 0xA1EB, 0xD10C, 0xC12D, 0xF14E, 0xE16F,
      0x1080, 0x00A1, 0x30C2, 0x20E3, 0x5004, 0x4025, 0x7046, 0x6067,
      0x83B9, 0x9398, 0xA3FB, 0xB3DA, 0xC33D, 0xD31C, 0xE37F, 0xF35E,
      0x02B1, 0x1290, 0x22F3, 0x32D2, 0x4235, 0x5214, 0x6277, 0x7256,
      0xB5EA, 0xA5CB, 0x95A8, 0x8589, 0xF56E, 0xE54F, 0xD52C, 0xC50D,
      0x34E2, 0x24C3, 0x14A0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405,
      0xA7DB, 0xB7FA, 0x8799, 0x97B8, 0xE75F, 0xF77E, 0xC71D, 0xD73C,
      0x26D3, 0x36F2, 0x0691, 0x16B0, 0x6657, 0x7676, 0x4615, 0x5634,
      0xD94C, 0xC96D, 0xF90E, 0xE92F, 0x99C8, 0x89E9, 0xB98A, 0xA9AB,
      0x5844, 0x4865, 0x7806, 0x6827, 0x18C0, 0x08E1, 0x3882, 0x28A3,
      0xCB7D, 0xDB5C, 0xEB3F, 0xFB1E, 0x8BF9, 0x9BD8, 0xABBB, 0xBB9A,
      0x4A75, 0x5A54, 0x6A37, 0x7A16, 0x0AF1, 0x1AD0, 0x2AB3, 0x3A92,
      0xFD2E, 0xED0F, 0xDD6C, 0xCD4D, 0xBDAA, 0xAD8B, 0x9DE8, 0x8DC9,
      0x7C26, 0x6C07, 0x5C64, 0x4C45, 0x3CA2, 0x2C83, 0x1CE0, 0x0CC1,
      0xEF1F, 0xFF3E, 0xCF5D, 0xDF7C, 0xAF9B, 0xBFBA, 0x8FD9, 0x9FF8,
      0x6E17, 0x7E36, 0x4E55, 0x5E74, 0x2E93, 0x3EB2, 0x0ED1, 0x1EF0
    ].freeze

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
              break if count >= 255
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
      String.new('', encoding: 'ASCII-8BIT').tap do |result|
        len = data.bytesize
        last_byte = data.getbyte(0)

        if last_byte == RLE_RUN_CHAR
          raise DecodeError, 'Orphaned RLE code at start'
        end

        result << last_byte
        pos = 1

        while pos < len
          byte = data.getbyte(pos)

          if byte == RLE_RUN_CHAR
            count = data.getbyte(pos + 1)

            if count == 0
              # indicates an escaped RLE_RUN_CHAR, so output it
              result << RLE_RUN_CHAR
            else
              # one less than count because we have already outputted the
              # character once during the previous iteration
              result << (last_byte.chr * (count - 1))
            end

            # skip count
            pos += 1
          else
            result << byte
          end

          last_byte = byte
          pos += 1
        end
      end
    end

    def crc_hqx(data, crc = 0)
      crc &= 0xFFFF
      len = data.bytesize

      data.each_byte do |byte|
        crc = ((crc << 8) & 0xFF00) ^ CRC_TABLE[(crc >> 8) ^ byte]
      end

      crc
    end
  end
end
