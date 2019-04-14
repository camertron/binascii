module Binascii
  module Utils
    class << self
      def each_byte_quad(data, &block)
        data.force_encoding('ASCII-8BIT')
        yield [nil, data.getbyte(0), data.getbyte(1), data.getbyte(2)]
        return if data.bytesize == 1

        data.each_byte.each_cons(4, &block)

        if data.bytesize > 2
          yield [data.getbyte(-3), data.getbyte(-2), data.getbyte(-1), nil]
        end

        yield [data.getbyte(-2), data.getbyte(-1), nil, nil]
      end

      def each_byte_pair(data, &block)
        data.force_encoding('ASCII-8BIT')
        data.each_byte.each_cons(2, &block)
        yield [data.getbyte(-1), nil]
      end

      def render_string(data)
        read_pos = 0
        write_pos = 0
        line_start_pos = 0
        result = ''

        each_byte_pair(data) do |current, trailing|
          if current == 13
            if trailing != 10
              write_pos = line_start_pos
              next
            end
          elsif current == 10
            line_start_pos = read_pos
          end

          if write_pos >= result.bytesize
            result << current
          else
            result.setbyte(write_pos, current)
          end

          read_pos += 1
          write_pos += 1
        end

        result
      end
    end
  end
end
