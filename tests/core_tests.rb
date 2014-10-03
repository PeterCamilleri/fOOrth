# coding: utf-8

require_relative '../lib/fOOrth'
require          'minitest/autorun'

#Test the monkey patches applied to the Object class.
class CoreTester < MiniTest::Unit::TestCase

  #Special initialize to track rake progress.
  def initialize(*all)
    $do_this_only_one_time = "" unless defined? $do_this_only_one_time

    if $do_this_only_one_time != __FILE__
      puts
      puts "Running test file: #{File.split(__FILE__)[1]}"
      $do_this_only_one_time = __FILE__
    end

    super(*all)
  end

  #Test out the bare minimum core elements
  def test_core_essentials
    assert_equal(XfOOrth.object_class.name, "Object")
    assert_equal(XfOOrth.class_class.name,  "Class")
    assert_equal(XfOOrth::VirtualMachine.name,  "VirtualMachine")

    assert_equal(XfOOrth.object_class.foorth_parent, nil)
    assert_equal(XfOOrth.class_class.foorth_parent.name, "Object")
    assert_equal(XfOOrth::VirtualMachine.foorth_parent.name, "Object")

    assert_equal(XfOOrth.object_class.foorth_class.name, "Class")
    assert_equal(XfOOrth.class_class.foorth_class.name, "Class")
    assert_equal(XfOOrth::VirtualMachine.foorth_class.name, "Class")

    assert_equal(XfOOrth.object_class.children["Class"].name, "Class")
    assert_equal(XfOOrth.class_class.children["Object"], nil)

    #This is not supported! Since virtual machines are associated with threads,
    #keeping track of them in a hash could serve as the source of a massive,
    #evil, nasty memory leak of DEATH!!!!
    assert_raises(NoMethodError) {XfOOrth::VirtualMachine.children}

    #This really should raise an exception, and it does!
    assert_raises(XfOOrth::XfOOrthError) do
      XfOOrth::VirtualMachine.new('Fails')
    end
  end

  #Test out some instances of Object
  def test_object_instances
    vm = XfOOrth.virtual_machine

    inst1 = XfOOrth.object_class.create_foorth_instance(vm)
    assert_equal(inst1.foorth_class.name, 'Object')
    assert_equal(inst1.name, 'Object instance.')

    inst2 = XfOOrth.object_class.create_foorth_instance(vm)
    assert(inst1 != inst2)
    assert_equal(inst1.class, inst2.class)
    assert_equal(inst1.foorth_class, inst2.foorth_class)
  end

  #Testing sub-classing
  def test_creating_subclasses
    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    # In fOOrth ==> class: MyClass
    #        or ==> Object subclass: MyClass
    my_class = XfOOrth.object_class.create_foorth_subclass("MyClass")

    assert_equal(XfOOrth.object_class.children["MyClass"], my_class)
    assert_equal(my_class, XfOOrth.all_classes["MyClass"])
    assert_equal(my_class.name, "MyClass")
    assert_equal(my_class.foorth_class, XfOOrth.class_class)
    assert_equal(my_class.foorth_parent, XfOOrth.object_class)

    # In fOOrth ==> MyClass .new inst1 !
    inst1 = my_class.create_foorth_instance(vm)
    assert_equal(inst1.foorth_class.name, 'MyClass')
    assert_equal(inst1.name, 'MyClass instance.')

    # In fOOrth ==> MyClass subclass: Other
    other = my_class.create_foorth_subclass("Other")

    assert_equal(my_class.children["Other"], other)
    assert_equal(other, XfOOrth.all_classes["Other"])
    assert_equal(other.name, "Other")
    assert_equal(other.foorth_class, XfOOrth.class_class)
    assert_equal(other.foorth_parent, my_class)

    # In fOOrth ==> Other .new inst2 !
    inst2 = other.create_foorth_instance(vm)

    assert(inst1 != inst2)
    assert_equal(inst2.foorth_class.name, 'Other')
    assert_equal(inst2.name, 'Other instance.')
  end

  #Test sending a method to an object. Namely the class method to the
  #fOOrth Object class.
  def test_sending_a_method_to_a_class
    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    #Construct the source code for our code block.
    cs = XfOOrth::SymbolMap.map('.class')

    # In fOOrth ==> Object .class
    src = "lambda \{|vm| vm.push(XfOOrth.object_class); vm.pop.#{cs}(vm); \}"

    #Create the block
    blk = eval src

    #Call the block
    blk.call(vm)

    #Test the results.
    assert_equal(XfOOrth.class_class, vm.pop)
  end

  #Test sending a method to the virtual machine. Namely the class method.
  def test_sending_a_method_to_the_vm
    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    #Construct the source code for our code block.
    cs = XfOOrth::SymbolMap.map('.class')

    # In fOOrth ==> vm .class
    src = "lambda \{|vm| vm.push(vm); vm.pop.#{cs}(vm); \}"

    #Create the block
    blk = eval src

    #Call the block
    blk.call(vm)

    #Test the results.
    assert_equal(XfOOrth::VirtualMachine, vm.pop)
  end

  #Testing method redefinition
  def test_method_redefining
    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    # In fOOrth ==> class: TestClass
    #        or ==> Object subclass: TestClass
    test_class = XfOOrth.object_class.create_foorth_subclass("TestClass")

    # In fOOrth ==> Object .new inst1 !
    inst1 = XfOOrth.object_class.create_foorth_instance(vm)

    # In fOOrth ==> TestClass .new inst2 !
    inst2 = test_class.create_foorth_instance(vm)

    #A lambda block used for all of the following tests.
    blk = lambda {|vm| vm.pop.foo(vm) }

    # In fOOrth ==> Object :: foo 4 ;
    XfOOrth.object_class.add_shared_method(:foo, &lambda{|vm| vm.push(4)})

    vm.push(inst1)
    blk.call(vm)
    assert_equal(4, vm.pop)

    vm.push(inst2)
    blk.call(vm)
    assert_equal(4, vm.pop)

    # In fOOrth ==> Object :: foo 5 ;
    XfOOrth.object_class.add_shared_method(:foo, &lambda{|vm| vm.push(5)})

    vm.push(inst1)
    blk.call(vm)
    assert_equal(5, vm.pop)

    vm.push(inst2)
    blk.call(vm)
    assert_equal(5, vm.pop)

    # In fOOrth ==> TestClass :: foo 6 ;
    test_class.add_shared_method(:foo, &lambda{|vm| vm.push(6)})

    blk = lambda {|vm| vm.pop.foo(vm) }

    vm.push(inst1)
    blk.call(vm)
    assert_equal(5, vm.pop)

    vm.push(inst2)
    blk.call(vm)
    assert_equal(6, vm.pop)

    # In fOOrth ==> Object :: foo 7 ;
    XfOOrth.object_class.add_shared_method(:foo, &lambda{|vm| vm.push(7)})

    blk = lambda {|vm| vm.pop.foo(vm) }

    vm.push(inst1)
    blk.call(vm)
    assert_equal(7, vm.pop)

    vm.push(inst2)
    blk.call(vm)
    assert_equal(6, vm.pop)
  end

  #Testing exclusive methods
  def test_exclusive_methods
    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    # In fOOrth ==> Object .new inst1 !
    inst1 = XfOOrth.object_class.create_foorth_instance(vm)

    # In fOOrth ==> Object .new inst2 !
    inst2 = XfOOrth.object_class.create_foorth_instance(vm)

    #A lambda block used for all of the following tests.
    blk = lambda {|vm| vm.pop.bar(vm) }

    # In fOOrth ==> Object :: bar 11 ;
    XfOOrth.object_class.add_shared_method(:bar, &lambda{|vm| vm.push(11)})

    vm.push(inst1)
    blk.call(vm)
    assert_equal(11, vm.pop)

    vm.push(inst2)
    blk.call(vm)
    assert_equal(11, vm.pop)

    # In fOOrth ==> inst2 @ ::: bar 22 ;
    inst2.add_exclusive_method(:bar, &lambda{|vm| vm.push(22)})

    vm.push(inst1)
    blk.call(vm)
    assert_equal(11, vm.pop)

    vm.push(inst2)
    blk.call(vm)
    assert_equal(22, vm.pop)

    # In fOOrth ==> Object :: bar 33 ;
    XfOOrth.object_class.add_shared_method(:bar, &lambda{|vm| vm.push(33)})

    vm.push(inst1)
    blk.call(vm)
    assert_equal(33, vm.pop)

    vm.push(inst2)
    blk.call(vm)
    assert_equal(22, vm.pop)
  end

  #Test that the children of Object class are set up correctly.
  def test_object_children
    children = XfOOrth.object_class.children

    assert_equal(children['Class'], XfOOrth.class_class)
    assert_equal(children['VirtualMachine'], XfOOrth::VirtualMachine)
  end

end