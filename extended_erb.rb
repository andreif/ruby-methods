require :erb

class ERB
  class Compiler
      
      
    def compile(s)
      enc = s.encoding
      raise ArgumentError, "#{enc} is not ASCII compatible" if enc.dummy?
      s = s.dup.force_encoding("ASCII-8BIT") # don't use constant Enoding::ASCII_8BIT for miniruby
      enc = detect_magic_comment(s) || enc
      out = Buffer.new(self, enc)

      content = ''
      scanner = make_scanner(s)
      scanner.scan do |token|
        next if token.nil? 
        next if token == ''
        if scanner.stag.nil?
          case token
          when PercentLine
            out.push("#{@put_cmd} #{content_dump(content)}") if content.size > 0
            content = ''

            if token.to_s[0] == '=' # this line has been added
              out.push("#{@insert_cmd}((#{token.to_s[1..-1]}\n).to_s)") # this line has been added
            else # this line has been added
              out.push(token.to_s)  # original line
            end # this line has been added
            out.cr # original line

          when :cr
            out.cr
          when '<%', '<%=', '<%#'
            scanner.stag = token
            out.push("#{@put_cmd} #{content_dump(content)}") if content.size > 0
            content = ''
          when "\n"
            content << "\n"
            out.push("#{@put_cmd} #{content_dump(content)}")
            content = ''
          when '<%%'
            content << '<%'
          else
            content << token
          end
        else
          case token
          when '%>'
            case scanner.stag
            when '<%'
              if content[-1] == ?\n
                content.chop!
                out.push(content)
                out.cr
              else
                out.push(content)
              end
            when '<%='
              out.push("#{@insert_cmd}((#{content}).to_s)")
            when '<%#'
              # out.push("# #{content_dump(content)}")
            end
            scanner.stag = nil
            content = ''
          when '%%>'
            content << '%>'
          else
            content << token
          end
        end
      end
      out.push("#{@put_cmd} #{content_dump(content)}") if content.size > 0
      out.close
      return out.script, enc
    end
      
      
  end
end
