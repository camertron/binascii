require_relative 'binascii/qp'
require_relative 'binascii/uu'
require_relative 'binascii/base64'
require_relative 'binascii/hqx'
require_relative 'binascii/crc32'
require_relative 'binascii/hex'

module Binascii
  include Qp
  include Uu
  include Base64
  include Hqx
  include Crc32
  include Hex

  extend Binascii
end
