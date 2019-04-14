require 'binascii'
require 'benchmark/ips'

qp_str = "J'interdis aux marchands de vanter trop leur marchandises. "\
  "Car ils se font vite pédagogues et t'enseignent comme but ce qui n'est "\
  "par essence qu'un moyen, et te trompant ainsi sur la route à suivre les "\
  "voilà bientôt qui te dégradent, car si leur musique est vulgaire ils te "\
  "fabriquent pour te la vendre une âme vulgaire."

encoded_qp_str = Binascii.b2a_qp(qp_str)

puts "b2a_qp:"

Benchmark.ips do |x|
  x.report('pack') do
    [qp_str].pack('M')
  end

  x.report('b2a_qp') do
    Binascii.b2a_qp(qp_str)
  end

  x.compare!
end

puts
puts "a2b_qp:"

Benchmark.ips do |x|
  x.report('unpack') do
    encoded_qp_str.unpack('M')
  end

  x.report('a2b_qp') do
    Binascii.a2b_qp(encoded_qp_str)
  end

  x.compare!
end
