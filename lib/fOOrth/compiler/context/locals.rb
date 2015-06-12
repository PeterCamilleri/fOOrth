# coding: utf-8

#* compiler/context/locals.rb - Support local methods in context.
module XfOOrth

  #* compiler/context/locals.rb - Support local methods in context.
  class Context

    #Create a local method on this context.
    #<br>Parameters:
    #* name - The name of the method to create.
    #* spec_class - The specification class to use.
    #* options - An array of options.
    #* block - A block to associate with the name.
    #<br>Returns
    #* The spec created for the shared method.
    def create_local_method(name, spec_class, options, &block)
      sym = SymbolMap.add_entry(name)
      self[sym] = spec_class.new(name, sym, options, &block)
    end

    #Remove a local method on this context.
    #<br>Parameters:
    #* The name of the method to remove.
    def remove_local_method(name)
      if (sym = SymbolMap.map(name))
        @data.delete(sym)
      else
        error "F90: Unable to remove local method #{name}"
      end
    end

  end
end
