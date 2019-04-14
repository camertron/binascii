require 'binascii'
require 'benchmark/ips'

base64_str = "The quick brown fox jumps over the lazy dog."
encoded_base64_str = Binascii.b2a_base64(base64_str)

puts "b2a_base64:"

Benchmark.ips do |x|
  x.report('pack') do
    [base64_str].pack('u')
  end

  x.report('b2a_base64') do
    Binascii.b2a_base64(base64_str)
  end

  x.compare!
end

puts
puts "a2b_base64:"

Benchmark.ips do |x|
  x.report('unpack') do
    encoded_base64_str.unpack('u')
  end

  x.report('a2b_base64') do
    Binascii.a2b_base64(encoded_base64_str)
  end

  x.compare!
end
