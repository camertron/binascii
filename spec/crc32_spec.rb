require 'spec_helper'

describe Binascii do
  describe '#crc32' do
    it do
      crc = described_class.crc32("Test the CRC-32 of")
      crc = described_class.crc32(" this string.", crc)
      expect(crc).to eq(1571220330)
    end
  end
end
