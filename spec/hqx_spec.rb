require 'spec_helper'

describe Binascii do
  def ascii8(str)
    str.force_encoding('ASCII-8BIT')
  end

  describe 'rle' do
    it do
      data = ('a' * 100) + 'b' + ('c' * 300)
      encoded = described_class.rlecode_hqx(data)
      expect(encoded).to eq(ascii8("a\x90dbc\x90\xffc\x90-"))
      decoded = described_class.rledecode_hqx(encoded)
      expect(decoded).to eq(data)
    end
  end

  describe 'hqx' do
    it do
      data = "The quick brown fox jumps over the lazy dog.\r\n" +
        (0...256).to_a.pack('C*') +
        "\r\nHello world.\n"

      rle = described_class.rlecode_hqx(data)
      a = described_class.b2a_hqx(rle)

      b, _ = described_class.a2b_hqx(a)
      res = described_class.rledecode_hqx(b)
      expect(res).to eq(data)
    end
  end

  describe '#crc_hqx' do
    it do
      crc = described_class.crc_hqx('Test the CRC-32 of', 0)
      crc = described_class.crc_hqx(" this string.", crc)
      expect(crc).to eq(14290)

      [0, 1, 0x1234, 0x12345, 0x12345678, -1].each do |crc|
        expect(described_class.crc_hqx('', crc)).to eq(crc & 0xffff)
      end
    end
  end
end
