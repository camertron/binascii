require 'spec_helper'

describe Binascii do
  describe '#a2b_base64' do
    it 'decodes correctly' do
      expect(described_class.a2b_base64("Zm9vYmFyYmF6\n")).to eq('foobarbaz')
    end
  end

  describe '#b2a_base64' do
    it 'encodes correctly' do
      expect(described_class.b2a_base64('foobarbaz')).to eq("Zm9vYmFyYmF6\n")
    end

    it 'does not include line breaks' do
      str = 'The majestic green albatross flitters in the moonlight'
      expect(described_class.b2a_base64(str).strip).to_not include("\n")
    end

    it 'does not include a trailing newline if requested' do
      expect(described_class.b2a_base64('foobarbaz', newline: false)).to eq('Zm9vYmFyYmF6')
    end
  end
end
