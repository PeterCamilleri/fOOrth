# coding: utf-8

#* compiler/process/get_token.rb - Get a complete language element.
module XfOOrth

  #* compiler/process/get_token.rb - Get a complete language element.
  class VirtualMachine

    #Get the next token structure from the source code or nil if none
    #can be found.
    #<br>Returns
    #* A Token structure or nil.
    def get_token
      return nil unless (word = parser.get_word)

      token = Token.new
      string_parms(token, word)
      generate_code(token, word)
      token
    end

  end
end
