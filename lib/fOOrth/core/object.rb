# coding: utf-8

#* The additions to the Ruby Object class required to support fOOrth.
class Object

  #Get the foorth name of this object.
  def foorth_name
    "#{self.class.foorth_name} instance"
  end

  #Access/create the object's exclusive fOOrth dictionary.
  #<br>Decree!
  #* These are to be the only reference to @_private_foorth_exclusive!
  def foorth_exclusive
    @_private_foorth_exclusive ||= Hash.new
  end

  #Does this object have exclusive methods defined on it?
  #<br>Decree!
  #* These are to be the only reference to @_private_foorth_exclusive!
  def foorth_has_exclusive?
    instance_variable_defined?(:@_private_foorth_exclusive)
  end

  #Create an exclusive method on this fOOrth object.
  #<br>Parameters:
  #* name - The name of the method to create.
  #* spec_class - The specification class to use.
  #* options - An array of options.
  #* block - A block to associate with the name.
  #<br>Returns
  #* The spec created for the shared method.
  def create_exclusive_method(name, spec_class, options, &block)
    sym = XfOOrth::SymbolMap.add_entry(name)
    spec = spec_class.new(name, sym, options, &block)
    cache_exclusive_method(sym, &spec.does)
    foorth_exclusive[sym] = spec
  end

  #Load the new exclusive method into the object.
  def cache_exclusive_method(symbol, &block)
    define_singleton_method(symbol, &block)
  rescue TypeError
    error "F13: Exclusive methods not allowed for type: #{self.class.foorth_name}"
  end

  #Map the symbol to a specification or nil if there is no mapping.
  def map_foorth_exclusive(symbol)
    (foorth_has_exclusive? && foorth_exclusive[symbol]) ||
    self.class.map_foorth_shared(symbol)
  end

  #The default foorth_init method does nothing.
  def foorth_init(_vm)
  end

  #The \method_missing hook is used to provide meaningful error messages
  #when problems are encountered.
  #<br>Parameters:
  #* symbol - The symbol of the missing method.
  #* args - Any arguments that were passed to that method.
  #* block - Any block that might have passed to the method.
  def method_missing(symbol, *args, &block)
    if (name = XfOOrth::SymbolMap.unmap(symbol))
      error "F20: A #{self.foorth_name} does not understand #{name} (#{symbol})."
    else
      super
    end
  end

end
