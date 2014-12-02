# coding: utf-8

#* interpreter/squash.rb - The fOOrth language array literal support module.
module XfOOrth

  #* interpreter/squash.rb - The fOOrth language do loop support module.
  class VirtualMachine

    #Compress the entire data stack into a single entry.
    def squash
      @data_stack = [@data_stack]
    end

    #Compress all the added entries into a single entry and revive the previous
    #contents of the data stack.
    def unsquash
      previous = @data_stack[0]
      data = @data_stack[1..-1]
      @data_stack = previous
      push(data)
    end

  end

end
