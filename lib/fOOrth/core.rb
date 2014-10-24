# coding: utf-8

require_relative 'compiler/word_specs'

require_relative 'core/object'
require_relative 'core/class'
require_relative 'core/virtual_machine'
require_relative 'core/proxy'

#* core.rb - The fOOrth language OO core.
module XfOOrth

  class << self
    #A short-cut for getting the hash of all fOOrth classes.
    attr_reader :all_classes

    #A short-cut for getting the fOOrth Object class.
    attr_reader :object_class

    #A short-cut for getting the fOOrth Class class.
    attr_reader :class_class
  end

  #A short-cut for getting the virtual machine of the current thread.
  def self.virtual_machine
    Thread.current[:vm]
  end

  #There is no short cut for getting the fOOrth VitualMachine class because
  #it also happens to be the Ruby VirtualMachine class.

  #==========================================================================
  # The Core Initialization Code Block. This code weaves the core of the
  # fOOrth OO system. This is done explicitly since Ruby can't do it for us.
  #==========================================================================

  #Set up a hash for all fOOrth class objects.
  @all_classes = Hash.new

  #Create the anonymous template class for the fOOrth class class. Each
  #instance of fOOrth class will be wrapped in one of these anonymous classes
  #to allow it to define methods independently. The fOOrth class of this
  #class is set to nil as a stand in.
  class_anon = Class.new(XClass, &lambda {|vm| @foorth_class = nil})

  #Create the instance of fOOrth class for fOOrth class class. At this point
  #there is no way to set the foorth_parent because it does not yet exist. So
  #the value nil is used as a temporary stand in.
  @class_class = class_anon.new('Class', nil)

  #Set the class of the fOOrth class to be the newly created fOOrth class.
  #This means that fOOrth class is an instance of itself! Of all the fOOrth
  #classes, it is unique in this respect.
  class_anon.foorth_class = @class_class

  #Create the anonymous template class for the fOOrth object class.
  #Note that it is also an instance of fOOrth class.
  object_anon = Class.new(XClass, &lambda {|vm| @foorth_class = XfOOrth.class_class})

  #Create the instance of fOOrth class for fOOrth object class. The fOOrth
  #Object class has no parent, so nil is the actual parent, not a stand in.
  @object_class = object_anon.new('Object', nil)

  #Predefine the default implementation of the init method. All classes
  #inherit this simple method.
  name = '.init'
  sym = SymbolMap.add_entry(name, :foorth_init)
  spec = MethodWordSpec.new(name, sym, [], &lambda {|vm| })
  @object_class.add_shared_method(:foorth_init, spec)

  #The Class class is a child of the Object class.
  @object_class.foorth_child_classes['Class'] = @class_class

  #Set up fOOrth Object as the parent of fOOrth Class. Now that the parent of
  #the Class class exists, set it!
  @class_class.set_foorth_parent(@object_class)

  #The VirtualMachine class is a child of the Object class.
  @object_class.foorth_child_classes['VirtualMachine'] = VirtualMachine

  #Explicitly add the VirtualMachine class to the hash of all classes
  all_classes['VirtualMachine'] = VirtualMachine

  #Create a virtual machine for the main thread.
  VirtualMachine.new('Main')

  #Create the symbol table entries for the core classes.
  @object_class.create_shared_method('Object', MacroWordSpec,
    ['"vm.push(XfOOrth.object_class); "'])

  @object_class.create_shared_method('Class', MacroWordSpec,
    ['"vm.push(XfOOrth.class_class); "'])

  @object_class.create_shared_method('VirtualMachine', MacroWordSpec,
    ['"vm.push(VirtualMachine); "'])

  #==========================================================================
  # Define some core methods.
  #==========================================================================

  #The .class method. This allows the class of any object to be determined.
  @object_class.create_shared_method('.class', MethodWordSpec, [],
    &lambda {|vm| vm.push(self.foorth_class)})

  #The .parent_class method. Retrieves the parent class of a class.
  @class_class.create_shared_method('.parent_class', MethodWordSpec, [],
    &lambda {|vm| vm.push(self.foorth_parent)})

  #The .is_class? method. Is the object a class object?
  sym = SymbolMap.add_entry('.is_class?', :foorth_is_class?)
  @object_class.create_shared_method('.is_class?', MethodWordSpec, [],
    &lambda {|vm| vm.push(false)})

  @class_class.create_shared_method('.is_class?', MethodWordSpec, [],
    &lambda {|vm| vm.push(true)})

  #Get the name of the object.
  @object_class.create_shared_method('.name', MethodWordSpec, [],
    &lambda {|vm| vm.push(self.name)})

end
