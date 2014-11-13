# coding: utf-8

#* The additions to the Ruby Class class required to support fOOrth.
class Class

  #==========================================================================
  # fOOrth Name Support
  #==========================================================================

  #Get the foorth name of this class.
  #<br>Decree!
  #* This is to be the only reference to @_private_foorth_name!
  def foorth_name
    @_private_foorth_name ||= name
  end


  #==========================================================================
  # Shared Method Support
  #==========================================================================

  #Access/create the class's shared fOOrth dictionary.
  #<br>Decree!
  #* This is to be the only reference to @_private_foorth_shared!
  def foorth_shared
    @_private_foorth_shared ||= Hash.new
  end

  #Create a shared method on this fOOrth class.
  #<br>Parameters:
  #* name - The name of the method to create.
  #* spec_class - The specification class to use.
  #* options - An array of options.
  #* block - A block to associate with the name.
  #<br>Returns
  #* The spec created for the shared method.
  def create_shared_method(name, spec_class, options, &block)
    sym = XfOOrth::SymbolMap.add_entry(name)
    spec = spec_class.new(name, sym, options, &block)
    define_method(sym, &spec.does)
    foorth_shared[sym] = spec
  end

  #Map the symbol to a specification or nil if there is no mapping.
  def map_foorth_shared(symbol)
    foorth_shared[symbol] || ((sc = superclass) && sc.map_foorth_shared(symbol))
  end

  #==========================================================================
  # Instance Creation Support
  #==========================================================================

  #Create an instance of this fOOrth class.
  #<br>Parameters:
  #* vm - The current fOOrth virtual machine.
  def create_foorth_instance(vm)
    (obj = self.new).foorth_init(vm)
    obj
  end


  #==========================================================================
  # Subclass/Proxy Creation Support
  #==========================================================================

  #Create a new fOOrth subclass of this class.
  #<br>Parameters:
  #* foorth_name - The foorth_name of the new sub-class.
  #<br>Returns:
  #* The subclass.
  #<br>Note:
  #* If a sub-class with the given name already exists, that class is returned.
  def create_foorth_subclass(foorth_name)
    unless (result = $ALL_CLASSES[foorth_name])
      error "Invalid class name" unless /^[A-Z][A-Za-z]*$/ =~ foorth_name

      result = Class.new(self) {
        @_private_foorth_name = foorth_name
      }

      ruby_name = 'XfOOrth_' + foorth_name
      XfOOrth.const_set(ruby_name, result)

      install_foorth_class(foorth_name)
    end

    result
  end

  #Add this class as a proxy class in the foorth class system.
  #<br>Returns:
  #* The proxy class.
  def create_foorth_proxy
    install_foorth_class(foorth_name) unless $ALL_CLASSES[foorth_name]

    self
  end

  private

  #Connect the class named foorth_name to the foorth system.
  #<br> Endemic Code Smells
  #* :reek:UtilityFunction
  def install_foorth_class(foorth_name)
    XfOOrth::SymbolMap.add_entry(foorth_name)
    $ALL_CLASSES[foorth_name] = XfOOrth::ClassWordSpec.new(foorth_name, nil, [])
  end

end
