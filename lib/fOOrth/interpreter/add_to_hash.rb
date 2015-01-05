# coding: utf-8

#* interpreter/add_to_hash.rb - The fOOrth language hash literal support module.
module XfOOrth

  #* interpreter/add_to_hash.rb - The fOOrth language hash literal support module.
  class VirtualMachine

    #Add the key and value to the hash being constructed.
    def add_to_hash
      key, value = popm(2)
      peek(1)[key] = value
    end

  end

end
