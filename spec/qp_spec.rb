require 'spec_helper'

describe Binascii do
  def ascii8(str)
    str.force_encoding('ASCII-8BIT')
  end

  describe '#a2b_qp' do
    def a2b_qp(str, options = {})
      described_class.a2b_qp(str, **options)
    end

    it do
      expect(a2b_qp('=')).to eq('')
    end

    it do
      expect(a2b_qp('= ')).to eq('= ')
    end

    it do
      expect(a2b_qp('==')).to eq('=')
    end

    it do
      expect(a2b_qp("=\nAB")).to eq('AB')
    end

    it do
      expect(a2b_qp("=\r\nAB")).to eq('AB')
    end

    it do
      expect(a2b_qp("=\rAB")).to eq('')
    end

    it do
      expect(a2b_qp("=\rAB\nCD")).to eq('CD')
    end

    it do
      expect(a2b_qp('=AB')).to eq(ascii8("\xab"))
    end

    it do
      expect(a2b_qp('=ab')).to eq(ascii8("\xab"))
    end

    it do
      expect(a2b_qp('=AX')).to eq('=AX')
    end

    it do
      expect(a2b_qp('=XA')).to eq('=XA')
    end

    it do
      expect(a2b_qp('=A')).to eq('=A')
    end

    it do
      expect(a2b_qp('_')).to eq('_')
    end

    it do
      expect(a2b_qp('_', header: true)).to eq(' ')
    end

    # @TODO
    # self.assertRaises(TypeError, b2a_qp, foo="bar")

    it do
      expect(a2b_qp("=00\r\n=00")).to eq("\x00\r\n\x00")
    end
  end

  describe '#b2a_qp' do
    def b2a_qp(str, options = {})
      described_class.b2a_qp(str, **options)
    end

    it do
      expect(b2a_qp("\xff\r\n\xff\n\xff")).to eq("=FF\r\n=FF\r\n=FF")
    end

    it do
      expect(b2a_qp(('0' * 75) + "\xff\r\n\xff\r\n\xff")).to eq(
        ('0' * 75) + "=\r\n=FF\r\n=FF\r\n=FF"
      )
    end

    it do
      expect(b2a_qp("\x7f")).to eq('=7F')
    end

    it do
      expect(b2a_qp('=')).to eq('=3D')
    end

    it do
      expect(b2a_qp('_')).to eq('_')
    end

    it do
      expect(b2a_qp('_', header: true)).to eq('=5F')
    end

    it do
      expect(b2a_qp('x y', header: true)).to eq('x_y')
    end

    it do
      expect(b2a_qp('x ', header: true)).to eq('x=20')
    end

    it do
      expect(b2a_qp('x y', header: true, quote_tabs: true)).to eq('x=20y')
    end

    it do
      expect(b2a_qp("x\ty", header: true)).to eq("x\ty")
    end

    it do
      expect(b2a_qp(' ')).to eq('=20')
    end

    it do
      expect(b2a_qp("\t")).to eq('=09')
    end

    it do
      expect(b2a_qp(' x')).to eq(' x')
    end

    it do
      expect(b2a_qp("\tx")).to eq("\tx")
    end

    it do
      expect(b2a_qp(" ")).to eq("=20")
    end

    it do
      expect(b2a_qp("\t")).to eq("=09")
    end

    it do
      expect(b2a_qp("\0")).to eq("=00")
    end

    it do
      expect(b2a_qp("\0\n")).to eq("=00\n")
    end

    it do
      expect(b2a_qp("\0\n", quote_tabs: true)).to eq("=00\n")
    end

    it do
      expect(b2a_qp("x y\tz")).to eq("x y\tz")
    end

    it do
      expect(b2a_qp("x y\tz", quote_tabs: true)).to eq('x=20y=09z')
    end

    it do
      expect(b2a_qp("x y\tz", is_text: false)).to eq("x y\tz")
    end

    it do
      expect(b2a_qp("x \ny\t\n")).to eq("x=20\ny=09\n")
    end

    it do
      expect(b2a_qp("x \ny\t\n", quote_tabs: true)).to eq("x=20\ny=09\n")
    end

    it do
      expect(b2a_qp("x \ny\t\n", is_text: false)).to eq("x =0Ay\t=0A")
    end

    it do
      expect(b2a_qp("x \ry\t\r")).to eq("x \ry\t\r")
    end

    it do
      expect(b2a_qp("x \ry\t\r", quote_tabs: true)).to eq("x=20\ry=09\r")
    end

    it do
      expect(b2a_qp("x \ry\t\r", is_text: false)).to eq("x =0Dy\t=0D")
    end

    it do
      expect(b2a_qp("x \r\ny\t\r\n")).to eq("x=20\r\ny=09\r\n")
    end

    it do
      expect(b2a_qp("x \r\ny\t\r\n", quote_tabs: true)).to eq("x=20\r\ny=09\r\n")
    end

    it do
      expect(b2a_qp("x \r\ny\t\r\n", is_text: false)).to eq("x =0D=0Ay\t=0D=0A")
    end

    it do
      expect(b2a_qp("x \r")).to eq("x \r")
    end

    it do
      expect(b2a_qp("x\t\r")).to eq("x\t\r")
    end

    it do
      expect(b2a_qp("x \r", quote_tabs: true)).to eq("x=20\r")
    end

    it do
      expect(b2a_qp("x\t\r", quote_tabs: true)).to eq("x=09\r")
    end

    it do
      expect(b2a_qp("x \r", is_text: false)).to eq('x =0D')
    end

    it do
      expect(b2a_qp("x\t\r", is_text: false)).to eq("x\t=0D")
    end

    it do
      expect(b2a_qp('.')).to eq('=2E')
    end

    it do
      expect(b2a_qp(".\n")).to eq("=2E\n")
    end

    it do
      expect(b2a_qp(".\r")).to eq("=2E\r")
    end

    it do
      expect(b2a_qp(".\0")).to eq('=2E=00')
    end

    it do
      expect(b2a_qp("a.\n")).to eq("a.\n")
    end

    it do
      french = "J'interdis aux marchands de vanter trop leur marchandises. "\
        "Car ils se font vite pédagogues et t'enseignent comme but ce qui n'est "\
        "par essence qu'un moyen, et te trompant ainsi sur la route à suivre les "\
        "voilà bientôt qui te dégradent, car si leur musique est vulgaire ils te "\
        "fabriquent pour te la vendre une âme vulgaire."

      expect(b2a_qp(french)).to eq(<<~END.gsub(/\r?\n/, "\r\n").strip)
        J'interdis aux marchands de vanter trop leur marchandises. Car ils se font =
        vite p=C3=A9dagogues et t'enseignent comme but ce qui n'est par essence qu'=
        un moyen, et te trompant ainsi sur la route =C3=A0 suivre les voil=C3=A0 bi=
        ent=C3=B4t qui te d=C3=A9gradent, car si leur musique est vulgaire ils te f=
        abriquent pour te la vendre une =C3=A2me vulgaire.
      END
    end
  end
end
