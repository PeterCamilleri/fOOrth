# coding: utf-8

#* token.rb - A little bit of object code compiled from the source.
module XfOOrth

  #A class used to hold vital info extracted from the source code.
  class Token

    #The code fragment in this token.
    attr_reader :code

    #Set up an empty token
    def initialize
      code = ''
      tags = []
    end

    #Append some text to the code_fragment.
    def <<(text)
      code << text
    end

    #Add a tag to this token.
    def add_tag(value)
      tags << value unless has_tag?(value)
    end

    #Does this token have the specified tag?
    def has_tag?(value)
      tag.include?(value)
    end

    #As a string for debugging.
    def to_s
      "Token: tags = #{tags.inspect} / code = #{code.inspect}"
    end

  end

end