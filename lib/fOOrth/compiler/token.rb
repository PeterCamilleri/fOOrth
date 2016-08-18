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
    #<br>Parameters
    #* text - A string of code to be appended to this token.
    #* tags - An optional array of tags to be added to this token.
    #<br>Possible tag values:
    #* :class - This token contains a class constant..
    #* :immediate - The token is executed, even in compile modes.
    #* :macro - This token contains an in-line macro.
    #* :numeric - This token contains a numeric literal.
    #* :procedure - This token contains a procedure literal.
    #* :string - This token contains a string literal.
    #* :stub - This token contains a stub spec.
    #* :temp - This token contains code from a temporary spec.
    #* none - Nothing special here. Move along, move along.
    def add(text, tags=nil)
      @code << text
      @tags.concat(tags).uniq! if tags
      self
    end

    #Does this token have the specified tag value?
    def has_tag?(value)
      @tags.include?(value)
    end

    #As a string for debugging.
    def to_s
      "Tags=#{@tags.inspect} Code=#{@code.inspect}"
    end

  end

end