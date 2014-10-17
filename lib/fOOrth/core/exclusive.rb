# coding: utf-8

#* core/exclusive.rb - The exclusive method support mixin module.
module XfOOrth

  #* \Exclusive - The exclusive method support mixin module.
  module Exclusive
    #Access/create the object's exclusive fOOrth dictionary.
    #<br>Decree!
    #* Avoid using @_foorth_exclusive any more than it already is! ! !
    def foorth_exclusive
      @_foorth_exclusive ||= Hash.new
    end

    #Does this object have exclusive methods defined on it?
    def has_exclusive?
      instance_variable_defined?(:@_foorth_exclusive) && !@_foorth_exclusive.empty?
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
      foorth_exclusive[symbol] || foorth_class.map_foorth_shared(symbol)
    end

    #Add an exclusive method to this fOOrth object.
    #<br>Parameters:
    #* symbol - The method symbol to be added.
    #* spec - The specification associated with this method.
    #<br>Note:
    #* Since exclusive methods are not subject to inheritance in the normal
    #  sense, the method is connected to the object immediately.
    def add_exclusive_method(symbol, spec)
      cache_exclusive_method(symbol, &spec.does)
      foorth_exclusive[symbol] = spec
    end

    #Cache all of the exclusive methods.
    def cache_all_exclusives
      foorth_exclusive.each do |symbol, spec|
        cache_exclusive_method(symbol, &spec.does)
      end
    end

    #Cache an exclusive method.
    #<br>Parameters:
    #* symbol - The method symbol to be added.
    #* spec - The block associated with this method.
    #<br>Note:
    #* Some targets do not allow exclusive methods, in which case an
    #  exception is raised by this method.
    def cache_exclusive_method(symbol, &block)
      define_singleton_method(symbol, &block)
    rescue TypeError
      error "Exclusive methods not allowed for type: #{foorth_class.name}"
    end

  end

end
