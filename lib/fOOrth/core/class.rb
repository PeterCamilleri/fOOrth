# coding: utf-8

#* The additions to the Ruby Class class required to support fOOrth.
class Class

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
    define_method(sym, &block)
    foorth_shared[sym] = spec
  end

  #Map the symbol to a specification or nil if there is no mapping.
  def map_foorth_shared(symbol)
    foorth_shared[symbol] || ((sc = superclass) && sc.map_foorth_shared(symbol))
  end

end

# Core Tsunami -- All that follows will be swept away... eventually...

require_relative 'shared'

#* core/class.rb - The generic class class of the fOOrth language system.
module XfOOrth

  #The \XClass class is basis for all fOOrth classes.
  class XClass < XObject
    include Shared

    #The base Ruby class for instances of this class.
    def instance_base_class
      XObject
    end

    #The base Ruby class for this class and its sub_classes.
    def class_base_class
      @class_base_class ||= XClass
    end

    #The foorth_name of the fOOrth class.
    attr_reader :foorth_name

    #The parent fOOrth class of this one.
    #<br>Special Cases:
    #* The \foorth_parent of the fOOrth class "Object" is nil.
    attr_reader :foorth_parent

    #Set the class's parent class for the case where this can not be done
    #when the class is constructed.
    def set_foorth_parent(foorth_parent)
      @foorth_parent = foorth_parent
    end

    #Create an new instance of a fOOrth class.
    #<br>Parameters:
    #* foorth_name - The foorth_name of this fOOrth class.
    #* \foorth_parent - The class that is the parent of this class.
    def initialize(foorth_name, foorth_parent)
      @foorth_name   = foorth_name
      @foorth_parent = foorth_parent
      foorth_class   = self

      all = XfOOrth.all_classes

      if all.has_key?(@foorth_name)
        error "Class #{@foorth_name} already exists."
      else
        all[@foorth_name]  = self
      end

      #Setup the Ruby shadow class used to create instances of this fOOrth class.
      @instance_template ||= Class.new(self.instance_base_class) do
        @foorth_class = foorth_class
      end

      #Create an access method for this class if possible.
      if foorth_parent
        XfOOrth.object_class.create_shared_method(foorth_name, ClassWordSpec, [])
      end
    end

    #Create a new fOOrth subclass of this class.
    #<br>Parameters:
    #* foorth_name - The foorth_name of the new sub-class.
    #* class_class - The foorth_class of the class being created. This must be
    #  derived from the class Class or really weird stuff is going to happen.
    #  If omitted, this will default to the Class class.
    #<br>Note:
    #* If a sub-class with the given name already exists, that class is returned.
    def create_foorth_subclass(foorth_name, class_class=nil)
      class_class ||= self.foorth_class

      anon = Class.new(class_class.class_base_class) {@foorth_class = class_class}

      new_class = anon.new(foorth_name, self)

      XfOOrth.const_set('XfOOrth_' + foorth_name, anon) #Anonymous no longer!
      foorth_child_classes[foorth_name] = new_class
    end

    #Create an instance of this fOOrth class.
    #<br>Parameters:
    #* vm - The current fOOrth virtual machine.
    def create_foorth_instance(vm)
      obj = @instance_template.new
      obj.foorth_init(vm)
      obj
    end

  end
end
