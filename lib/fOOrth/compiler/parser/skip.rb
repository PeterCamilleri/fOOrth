# coding: utf-8

#* compiler/parser/skip.rb - Skip over stuff in the source code.
module XfOOrth

  #* parser.rb - Parse source code from a code source.
  class Parser

    #Skip over any white space.
    #<br>Returns:
    #* The first non-white space character or nil if none were found.
    def skip_white_space
      begin
        return nil unless (next_char = @source.get)
      end while next_char <= ' '

      next_char
    end

    #Skip over a portion of the source text until end of line detected.
    #<br>Returns:
    #* true
    def skip_to_eoln
      @source.get until @source.eoln?
      true
    end

    #Skip over a portion of the source text until a ')' detected.
    #<br>Returns:
    #* true
    #<br>Note:
    #* Raises an XfOOrthError exception on an unterminated comment.
    def skip_over_comment
      until @source.eoln?
        return true if @source.get == ')'
      end

      error "F10: Unbalanced comment detected."
    end

    #Skip till a non-white space or an end of line
    def skip_white_space_or_to_eoln
      while (next_char = @source.get)
        return next_char if (next_char > ' ') || @source.eoln?
      end
    end

  end

end
