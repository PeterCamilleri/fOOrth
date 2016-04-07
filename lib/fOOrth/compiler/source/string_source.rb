# coding: utf-8

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

    #What is the source of this text?
    def source_name
      "A string."
    end

    #A string source has no file name to return.
    def file_name
      nil
    end

  end

end
