# coding: utf-8

require_relative 'core/object'
require_relative 'core/class'
require_relative 'core/virtual_machine'

#* core.rb - The fOOrth language OO core.
module XfOOrth

  #A short-cut for getting the hash of all fOOrth classes.
  def self.all_classes
    @all_classes
  end

  #A short-cut for getting the fOOrth Object class.
  def self.object_class
    @object_class
  end

  #A short-cut for getting the fOOrth Class class.
  def self.class_class
    @class_class
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

  #Predefine some essential name mappings
  SymbolMap.add_entry('.init', symbol: :init)

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
  @object_class.add_shared_method(:init, &lambda {|vm| })

  #The Class class is a child of the Object class.
  @object_class.children['Class'] = @class_class

  #Set up fOOrth Object as the parent of fOOrth Class. Now that the parent of
  #the Class class exists, set it!
  @class_class.set_foorth_parent(@object_class)

  #The VirtualMachine class is a child of the Object class.
  @object_class.children['VirtualMachine'] = VirtualMachine

  #Explicitly add the VirtualMachine class to the hash of all classes
  all_classes['VirtualMachine'] = VirtualMachine

  #Create a virtual machine for the main thread.
  VirtualMachine.new('main')

  #Create the symbol table entries for the core classes.
  SymbolMap.add_entry('Object')
  SymbolMap.add_entry('Class')
  SymbolMap.add_entry('VirtualMachine')

  #==========================================================================
  # Define some core methods.
  #==========================================================================

  #The .class method. This allows the class of any object to be determined.
  sym = SymbolMap.add_entry('.class')
  @object_class.add_shared_method(sym, &lambda {|vm| vm.push(self.foorth_class)})

  #The .parent_class method. Retrieves the parent class of a class.
  sym = SymbolMap.add_entry('.parent_class')
  @class_class.add_shared_method(sym, &lambda {|vm| vm.push(self.foorth_parent)})

  #The .is_class? method. Is the object a class object?
  sym = SymbolMap.add_entry('.is_class?')
  @object_class.add_shared_method(sym, &lambda {|vm| vm.push(false)})
  @class_class.add_shared_method(sym, &lambda {|vm| vm.push(true)})

  #==========================================================================
  # The end of the Core Initialization Code Block.
  #==========================================================================

end
