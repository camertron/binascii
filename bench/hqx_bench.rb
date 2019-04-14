require 'binascii'
require 'benchmark/ips'

hqx_str = "The quick brown fox jumps over the lazy dog."
encoded_hqx_str = Binascii.b2a_hqx(hqx_str) + ':'

puts "b2a_hqx:"

Benchmark.ips do |x|
  x.report('b2a_hqx') do
    Binascii.b2a_hqx(hqx_str)
  end
end

puts
puts "a2b_hqx:"

Benchmark.ips do |x|
  x.report('a2b_hqx') do
    Binascii.a2b_hqx(encoded_hqx_str)
  end
end

puts
puts "rlecode_hqx:"

Benchmark.ips do |x|
  x.report('rlecode_hqx') do
    Binascii.rlecode_hqx(hqx_str)
  end
end
