require 'binascii'
require 'benchmark/ips'

uu_str = "The quick brown fox jumps over the lazy dog."
encoded_uu_str = Binascii.b2a_uu(uu_str)

puts "b2a_uu:"

Benchmark.ips do |x|
  x.report('pack') do
    [uu_str].pack('u')
  end

  x.report('b2a_qp') do
    Binascii.b2a_uu(uu_str)
  end

  x.compare!
end

puts
puts "a2b_uu:"

Benchmark.ips do |x|
  x.report('unpack') do
    encoded_uu_str.unpack('u')
  end

  x.report('a2b_uu') do
    Binascii.a2b_uu(encoded_uu_str)
  end

  x.compare!
end
