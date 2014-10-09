# coding: utf-8

require_relative 'source'

#* compiler/string_source.rb - Uses a string as a source of fOOrth source code.
module XfOOrth

  #The StringSource class used to extract fOOrth source code
  #from a string.
  class StringSource < AbstractSource

    #Initialize from a string.
    #<br>Parameters:
    #* string - A string of fOOrth source code.
    def initialize(string)
      @string_list = string.split("\n")
      @read_step   = @string_list.each
      super()
    end

  end

end
