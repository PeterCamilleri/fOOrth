# coding: utf-8

require_relative 'token'

#* parser.rb - Parse source code from a code source.
module XfOOrth

  #* parser.rb - Parse source code from a code source.
  class Parser

    #The source of the text to be parsed.
    attr_reader :source

    #Initialize this parser.
    #<br>Parameters
    #* source - The source of the text to be parsed.
    def initialize(source)
      @source = source
    end

    #Get the next forth word from the source code source.
    #<br>Returns:
    #* A string with the next language element or nil if none could be found.
    def get_word
      #Skip white space.
      begin
        return nil unless (next_char = @source.get)
      end while next_char <= ' '

      #Gather the word token.
      word = ''

      begin
        word << next_char

        #Check for the three special cases.
        break if (word == '(') || (word == '//') || (next_char == '"')

        next_char = @source.get
      end while next_char && next_char > ' '

      word
    end

    #Get the balance of a string from the source code source.
    def get_string
      done = false
      result = ''

      begin
        next_char = @source.get

        if next_char == "\\"
          result << process_backslash
        elsif next_char == '"'
          done = true
        elsif @source.eoln?
          done = true
        elsif next_char >= ' '
          result << next_char
        end
      end until done

      result
    end

    #Process a backlash character found with a string in the source text.
    def process_backslash
      next_char = @source.get

      if next_char == ' ' && @source.eoln?
        next_char = @source.get
        next_char = @source.get until next_char > ' ' || @source.eoln?
      elsif next_char != '\\' && next_char != '"'
        next_char = ''
      end

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

      error "Unbalanced comment detected."
    end

  end

end
