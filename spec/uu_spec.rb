require 'spec_helper'

describe Binascii do
  def ascii8(str)
    str.force_encoding('ASCII-8BIT')
  end

  describe '#a2b_uu' do
    def a2b_uu(str)
      described_class.a2b_uu(str)
    end

    it do
      expect(a2b_uu("\x7f")).to eq(ascii8("\x00") * 31)
    end

    it do
      expect(a2b_uu("\x80")).to eq(ascii8("\x00") * 32)
    end

    it do
      expect(a2b_uu("\xff")).to eq(ascii8("\x00") * 31)
    end

    it do
      expect(a2b_uu(" \n")).to eq('')
    end

    it do
      expect(a2b_uu("`\n")).to eq('')
    end

    it do
      expect(a2b_uu("$`$-A=```\n")).to eq(a2b_uu("$ $-A=   \n"))
    end
  end

  describe '#b2a_uu' do
    def b2a_uu(str, options = {})
      described_class.b2a_uu(str, **options)
    end

    it do
      expect(b2a_uu('x')).to eq("!>   \n")
    end

    it do
      expect(b2a_uu('')).to eq(" \n")
    end

    it do
      expect(b2a_uu('', backtick: true)).to eq("`\n")
    end

    it do
      expect(b2a_uu("\x00Cat")).to eq("$ $-A=   \n")
    end

    it do
      expect(b2a_uu("\x00Cat", backtick: true)).to eq("$`$-A=```\n")
    end
  end
end
