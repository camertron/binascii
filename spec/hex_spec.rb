require 'spec_helper'

describe Binascii do
  let(:s) { "{s\005\000\000\000worldi\002\000\000\000s\005\000\000\000helloi\001\000\000\0000" }
  let(:t) { described_class.b2a_hex(s) }
  let(:u) { described_class.a2b_hex(t) }

  it do
    expect(s).to eq(u)
  end

  describe '#b2a_hex' do
    it do
      expect(described_class.b2a_hex(s)).to eq(t)
    end
  end

  describe '#a2b_hex' do
    it do
      expect(described_class.a2b_hex(t)).to eq(u)
    end
  end
end
