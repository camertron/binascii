# frozen_string_literal: true

require 'zlib'

module Binascii
  module Crc32
    def crc32(data, crc = 0)
      Zlib.crc32(data, crc)
    end
  end
end
