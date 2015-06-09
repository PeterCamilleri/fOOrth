# coding: utf-8

#* compiler/context/locals.rb - Support local methods in context.
module XfOOrth

  #* compiler/context/locals.rb - Support local methods in context.
  class Context

    #Create a local method on this context.
    #<br>Parameters:
    #* The name of the method to create.
    #* An array of options.
    #* A block to associate with the name.
    #<br>Returns
    #* The spec created for the shared method.
    def create_local_method(name, options, &block)
      sym = SymbolMap.add_entry(name)
      self[sym] = LocalSpec.new(name, sym, options, &block)
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
