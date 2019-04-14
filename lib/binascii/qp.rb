# frozen_string_literal: true

require 'binascii/utils'

module Binascii
  module Qp
    LINE_MAX = 76

    def a2b_qp(str, header: false)
      return '' if str == '='
      str = Utils.render_string(str) if str.index("\r")
      first_byte = str.getbyte(0)

      str = if first_byte == 95 || first_byte == 61
        str
      else
        idx = str.index("\n")
        idx ? str[(idx + 1)..-1] : ''
      end

      str = str.unpack('M').first

      str.gsub!('==', '=')
      str.gsub!('_', ' ') if header

      str
    end

    def b2a_qp(data, header: false, quote_tabs: false, is_text: true)
      @byte_cache ||= {}

      String.new.tap do |result|
        data_size = data.bytesize
        line_len = 0
        cr_lf = false

        Utils.each_byte_quad(data) do |leading, byte, trailing1, trailing2|
          repl = nil
          repl_size = 1

          if byte == 13  # linefeed, \r
            if is_text
              repl = byte
            else
              repl = '=0D'
            end
          elsif byte == 10  # carriage return, \n
            if is_text
              cr_lf = true if leading == 13

              if cr_lf && leading != 13
                repl = "\r\n"
                repl_size = 2
              else
                repl = byte
              end
            else
              repl = '=0A'
            end
          elsif byte == 95  # underscore
            repl = header ? '=5F' : '_'
            repl_size = repl.bytesize
          elsif byte == 32  # space
            if (!trailing1 || trailing1 == 10 || (trailing1 == 13 && trailing2 == 10) || quote_tabs) && is_text
              repl = "=20"
              repl_size = 3
            else
              repl = header ? '_' : ' '
            end
          elsif byte == 9  # tab
            if (!trailing1 || trailing1 == 10 || (trailing1 == 13 && trailing2 == 10) || quote_tabs) && is_text
              repl = "=09"
              repl_size = 3
            else
              repl = "\t"
            end
          elsif byte == 46  # period
            # I don't understand these rules, but whatever
            if line_len == 0 && (!trailing1 || trailing1 == 10 || trailing1 == 13 || trailing1 == 0)
              repl = '=2E'
              repl_size = 3
            else
              repl = '.'
            end
          elsif (byte >= 33 && byte <= 126) && byte != 61  # all printable ascii characters except '='
            repl = byte
          else
            repl = (@byte_cache[byte] ||= "=#{byte.to_s(16).rjust(2, '0').upcase}")
            repl_size = 3
          end

          if (line_len + repl_size) > LINE_MAX - 1
            line_len = 0
            result << "=\r\n"
            result << repl
          else
            result << repl
          end

          line_len += repl_size
        end
      end
    end
  end
end
