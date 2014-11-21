# coding: utf-8

#* The additions to the Ruby Class class required to support fOOrth.
class Class

  #Get the foorth name of this class.
  #<br>Decree!
  #* These are to be the only references to @_private_foorth_name!
  def foorth_name
    @_private_foorth_name ||= name
  end

  #Set the foorth name of this class.
  #<br>Decree!
  #* These are to be the only references to @_private_foorth_name!
  def foorth_name=(new_name)
    @_private_foorth_name = new_name
  end

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

  #Create an instance of this fOOrth class.
  #<br>Parameters:
  #* vm - The current fOOrth virtual machine.
  def create_foorth_instance(vm)
    (obj = self.new).foorth_init(vm)
    obj
  end

  #Create a new fOOrth subclass of this class.
  #<br>Parameters:
  #* foorth_name - The foorth_name of the new sub-class.
  #<br>Returns:
  #* The spec of the subclass.
  #<br>Note:
  #* If a sub-class with the given name already exists, an exception is raised.
  def create_foorth_subclass(foorth_name)
    error "The class #{foorth_name} already exists." if $FOORTH_GLOBALS[foorth_name]
    error "Invalid class name" unless /^[A-Z][A-Za-z0-9]*$/ =~ foorth_name

    new_class = Class.new(self) {
      self.foorth_name = foorth_name
    }

    XfOOrth.const_set('XfOOrth_' + foorth_name, new_class)
    install_foorth_class(foorth_name, new_class)
  end

  #Add this class as a proxy class in the foorth class system.
  #<br>Returns:
  #* The spec of the proxy class.
  def create_foorth_proxy
    error "The class #{foorth_name} already exists." if $FOORTH_GLOBALS[foorth_name]

    install_foorth_class(foorth_name, self)
  end

  private

  #Connect the class named foorth_name to the foorth system.
  #<br>Returns:
  #* The newly created spec object.
  #<br> Endemic Code Smells
  #* :reek:UtilityFunction
  def install_foorth_class(foorth_name, new_class)
    XfOOrth::SymbolMap.add_entry(foorth_name)
    $FOORTH_GLOBALS[foorth_name] = XfOOrth::ClassSpec.new(new_class, nil, [])
  end

end
