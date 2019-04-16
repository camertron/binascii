module Binascii
  module Base64
    def a2b_base64(string)
      string.unpack('m').first
    end

    def b2a_base64(data, newline: true)
      result = [data].pack('m').gsub!("\n", '')
      result << "\n" if newline
      result
    end
  end
end
