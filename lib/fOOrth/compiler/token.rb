# coding: utf-8

#* token.rb - A parsed little bit of code extracted from the source.
module XfOOrth

  #A structure that holds vital info extracted from the source code.
  Token = Struct.new(:code_fragment, :tag) do

    #Is this token tagged for immediate execution?
    def immediate?
      self.tag == :immediate
    end

    #As a string for debugging.
    def to_s
      "Token: #{self.code_fragment} / type =  #{self.tag.inspect}"
    end

  end

end