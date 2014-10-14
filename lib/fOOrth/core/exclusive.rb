# coding: utf-8

#* core/exclusive.rb - The exclusive method support mixin module.
module XfOOrth

  #* \Exclusive - The exclusive method support mixin module.
  module Exclusive

    #Does this object have exclusive methods defined on it?
    def has_exclusive?
      instance_variable_defined?(:@exclusive) && !@exclusive.empty?
    end

    #Create an exclusive method on this fOOrth object.
    #<br>Parameters:
    #* The name of the method to create.
    #* The specification class to use.
    #* An array of options.
    #* A block to associate with the name.
    def create_exclusive_method(name, spec_class, options, &block)
      sym = SymbolMap.add_entry(name)
      spec = spec_class.new(name, sym, options, &block)
      add_exclusive_method(sym, spec)
    end

    #Map the symbol to a specification or nil if there is no mapping.
    def map_exclusive(symbol)
      @exclusive[symbol] || foorth_class.map_shared(symbol)
    end

    #Add an exclusive method to this fOOrth object.
    #<br>Parameters:
    #* symbol - The method symbol to be added.
    #* spec - The specification associated with this method.
    #<br>Note:
    #* Since exclusive methods are not subject to inheritance in the normal
    #  sense, the method is connected to the object immediately.
    def add_exclusive_method(symbol, spec)
      @exclusive ||= Hash.new
      @exclusive[symbol] = spec
      define_singleton_method(symbol, &spec.does)
    end

    #Cache all of the exclusive methods.
    def cache_all_exclusives
      @exclusive.each do |symbol, spec|
        define_singleton_method(symbol, &spec.does)
      end
    end

  end

end
