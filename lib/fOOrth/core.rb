# coding: utf-8

require_relative 'core/object'
require_relative 'core/class'
require_relative 'core/virtual_machine'


#* core.rb - The fOOrth language OO core.
module XfOOrth

  #Core initialization code block.

  #Predefine some essential name mappings
  SymbolMap.add_special('init', :init)
  cs = SymbolMap.add_entry('class')

  #Create the anonymous template class for the fOOrth class class.
  class_anon = Class.new(XClass, &lambda {|vm| @foorth_class = nil})

  #Create the instance of fOOrth class for fOOrth class class.
  class_class = class_anon.new('Class', nil)

  #fOOrth class is an instance of fOOrth class!
  class_anon.foorth_class = class_class

  #Create the anonymous template class for the fOOrth object class.
  #Note that it is also an instance of fOOrth class.
  object_anon = Class.new(XClass, &lambda {|vm| @foorth_class = class_class})

  #Create the instance of fOOrth class for fOOrth object class.
  object_class = object_anon.new('Object', nil)

  #Predefine the default implementation of the init method.
  object_class.add_shared_method(:init, &lambda {|vm| })

  #Predefine some essential methods.
  object_class.add_shared_method(cs, &lambda {|vm| vm.push(self.foorth_class)})

  #Set up fOOrth Object as the parent of fOOrth Class.
  object_class.children['Class'] = class_class
  class_class.set_foorth_parent(object_class)

end
