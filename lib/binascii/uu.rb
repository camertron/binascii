# frozen_string_literal: true

module Binascii
  module Uu
    def b2a_uu(data, backtick: false)
      if data.bytesize == 0
        backtick ? "`\n" : " \n"
      else
        result = [data].pack('u')
        backtick ? result : result.gsub!('`', ' ')
      end
    end

    def a2b_uu(str)
      str.force_encoding('ASCII-8BIT')
      len = (str.getbyte(0) - 32) & 077
      str.unpack('u').first.rjust(len, "\0")
    end
  end
end
