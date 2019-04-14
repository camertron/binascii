require 'binascii/qp'
require 'binascii/uu'
require 'binascii/base64'
require 'binascii/hqx'

module Binascii
  include Qp
  include Uu
  include Base64
  include Hqx

  extend Binascii
end
