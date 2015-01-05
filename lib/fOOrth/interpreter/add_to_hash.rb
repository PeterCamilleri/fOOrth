# coding: utf-8

#* interpreter/add_to_hash.rb - The fOOrth language hash literal support module.
module XfOOrth

  #* interpreter/add_to_hash.rb - The fOOrth language hash literal support module.
  class VirtualMachine

    #Compress all the added entries into a single entry and revive the previous
    #contents of the data stack.
    def add_to_hash
      key, value = popm(2)
      peek(1)[key] = value
    end

  end

end
