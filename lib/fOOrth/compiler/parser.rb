# coding: utf-8

require_relative 'parser/get_string'
require_relative 'parser/skip'
require_relative 'parser/normal'
require_relative 'parser/special'

#* compiler/parser.rb - Parse source code from a code source.
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

  end

end
