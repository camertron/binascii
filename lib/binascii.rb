require 'binascii/qp'
require 'binascii/uu'
require 'binascii/base64'
require 'binascii/hqx'
require 'binascii/crc32'
require 'binascii/hex'

module Binascii
  include Qp
  include Uu
  include Base64
  include Hqx
  include Crc32
  include Hex

  extend Binascii
end
