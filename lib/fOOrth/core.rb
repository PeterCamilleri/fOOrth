# coding: utf-8

require_relative 'compiler/word_specs'
require_relative 'core/core_access'
require_relative 'core/object'
require_relative 'core/class'
require_relative 'core/virtual_machine'
require_relative 'core/proxy'

#* core.rb - The fOOrth language OO core.
module XfOOrth
  extend CoreAccess

  #==========================================================================
  # The Core Initialization Code Block. This code weaves the core of the
  # fOOrth OO system. This is done explicitly since Ruby can't do it for us.
  #==========================================================================

  #Set up a hash for all fOOrth class objects.
  @all_classes = Hash.new

  #Create the named shadow class for the fOOrth Class class. Each
  #instance of fOOrth class will be wrapped in one of these classes
  #to allow them to define methods independently. Also, the fOOrth
  #class of this class is set to nil as a stand in.
  class_anon = Class.new(XClass, &lambda {|vm| @foorth_class = nil})
  XfOOrth.const_set("XfOOrth_Class", class_anon)

  #Create the instance of fOOrth class for fOOrth Class class. At this point
  #there is no way to set the foorth_parent because it does not yet exist. So
  #the value nil is used as a temporary stand in. It is set below.
  @class_class = class_anon.new('Class', nil)

  #Set the class of the fOOrth Class to be the newly created fOOrth Class.
  #This means that fOOrth Class is an instance of itself! Of all the fOOrth
  #classes, it is unique in this respect.
  class_anon.foorth_class = @class_class

  #Create the named shadow class for the fOOrth Object class.
  #Note that it is also an instance of fOOrth Class class.
  object_anon = Class.new(XClass, &lambda {|vm| @foorth_class = XfOOrth.class_class})
  XfOOrth.const_set("XfOOrth_Object", object_anon)

  #Create the instance of fOOrth class for fOOrth Object class. The fOOrth
  #Object class has no parent, so nil is the actual parent, not a stand in.
  @object_class = object_anon.new('Object', nil)

  #Predefine the default implementation of the .init method. This method must
  #exist at this point in order to proceed further.
  name = '.init'
  sym = SymbolMap.add_entry(name, :foorth_init)
  spec = PublicWordSpec.new(name, sym, [], &lambda {|vm| })
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

  #Create a virtual machine instance for the main thread. The constructor
  #connects the new instance to a thread variable so we don't need to do
  #anything with it here.
  VirtualMachine.new('Main')
end
