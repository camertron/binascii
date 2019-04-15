require 'binascii'
require 'benchmark/ips'

hex_str = "The quick brown fox jumps over the lazy dog."
encoded_hex_str = Binascii.b2a_hex(hex_str)

Benchmark.ips do |x|
  x.report('b2a_hex') do
    Binascii.b2a_hex(hex_str)
  end
end

Benchmark.ips do |x|
  x.report('a2b_hex') do
    Binascii.a2b_hex(encoded_hex_str)
  end
end
