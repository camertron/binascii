# frozen_string_literal: true

module Binascii
  module Hex
    A2B_LO = (('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a)
      .each_with_object({}).with_index { |(chr, ret), idx| ret[chr.ord] = idx }
      .freeze

    A2B_HI = A2B_LO
      .each_with_object({}) { |(ord, idx), ret| ret[ord] = idx + (0xF * idx) }
      .freeze

    B2A = (0...256).each_with_object({}) do |b, ret|
      ret[b] = b.to_s(16).rjust(2, '0')
    end.freeze

    def b2a_hex(data)
      String.new('', encoding: 'ASCII-8BIT').tap do |result|
        data.each_byte do |byte|
          result << B2A[byte]
        end
      end
    end

    alias_method :hexlify, :b2a_hex

    def a2b_hex(data)
      String.new('', encoding: 'ASCII-8BIT').tap do |result|
        len = data.bytesize
        pos = 0

        while pos < len
          result << (A2B_HI[data.getbyte(pos)] | A2B_LO[data.getbyte(pos + 1)])
          pos += 2
        end
      end
    end

    alias_method :unhexlify, :a2b_hex
  end
end
