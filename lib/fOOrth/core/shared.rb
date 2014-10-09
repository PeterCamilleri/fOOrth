# coding: utf-8

#* core/shared.rb - A mixin to support for shared methods.
module XfOOrth
  #* \Shared - A mixin to support for shared methods.
  module Shared
    #Create a shared method on this fOOrth class.
    #<br>Parameters:
    #* The name of the method to create.
    #* The specification class to use.
    #* An array of options.
    #* A block to associate with the name.
    def create_shared_method(name, spec_class, options, &block)
      sym = SymbolMap.add_entry(name)
      spec = spec_class.new(name, sym, options, &block)
      add_shared_method(sym, spec)
    end

    #Search the object class dictionaries for the named instance method and add
    #it to the target class.
    #<br>Parameters:
    #* name - The symbol of the method name to be added.
    #* target_class - The class to which the method is added.
    #<br>Returns:
    #* True on success else false if name could not be found.
    #<br>Endemic Code Smells
    #* :reek:FeatureEnvy
    def link_shared_method(name, target_class)
      current = self

      while current
        dictionary = current.shared

        if dictionary.has_key?(name)
          target_class.cache_shared_method(name, &dictionary[name].does)
          return true
        end

        current = current.foorth_parent
      end
    end

    #Map the symbol to a specification or nil if there is no mapping.
    def map_shared(symbol)
      shared[symbol] || (foorth_parent && foorth_parent.map_shared(symbol))
    end

    #Add an instance method to this fOOrth class.
    #<br>Parameters:
    #* symbol - The method symbol to be added.
    #* spec - The specification associated with this method.
    #<br>Note:
    #* The method cache for this symbol is purged for this class and all child
    #  classes except where the child classes already have there own method.
    def add_shared_method(symbol, spec)
      @shared.delete(symbol)
      purge_shared_method(symbol)
      @shared[symbol] = spec
    end

    #Purge the instance method cache for the specified symbol.
    def purge_shared_method(symbol)
      unless @shared.has_key?(symbol)
        @instance_template.purge_method(symbol)
        children.each {|name, child| child.purge_shared_method(symbol)}
      end
    end
  end
end
