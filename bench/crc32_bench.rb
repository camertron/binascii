require 'binascii'
require 'benchmark/ips'

crc_str = "The quick brown fox jumps over the lazy dog."

puts "crc32:"

Benchmark.ips do |x|
  x.report('crc32') do
    Binascii.crc32(crc_str)
  end
end
