# coding: utf-8

#* compiler/token.rb - A little bit of object code compiled from the source.
module XfOOrth

  #A class used to hold vital info extracted from the source code.
  class Token

    #The code fragment in this token.
    attr_reader :code

    #Set up an empty token
    def initialize
      @code = ''
      @tags = []
    end

    #Append some text/tags to the code_fragment.
    def add(text, tags=nil)
      @code << text
      @tags.concat(tags).uniq! if tags
    end

    #Does this token have the specified tag?
    def has_tag?(value)
      @tags.include?(value)
    end

    #As a string for debugging.
    def to_s
      "Tags=#{@tags.inspect} Code=#{@code.inspect}"
    end

  end

end