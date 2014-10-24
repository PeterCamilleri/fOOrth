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

    assert_equal(XfOOrth.object_class.foorth_child_classes["Class"].name, "Class")
    assert_equal(XfOOrth.class_class.foorth_child_classes["Object"], nil)

    #The VirtualMachine class must be childfree!
    assert_equal(XfOOrth::VirtualMachine.foorth_child_classes, {})

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
    assert_equal(inst1.name, 'Object instance')

    inst2 = XfOOrth.object_class.create_foorth_instance(vm)
    assert(inst1 != inst2)
    assert_equal(inst1.class, inst2.class)
    assert_equal(inst1.foorth_class, inst2.foorth_class)
  end

  #Test that VM instances behave too.
  def test_vm_instances
    vm = XfOOrth.virtual_machine
    assert_equal(vm.name, "VirtualMachine instance <Main>.")
  end

  #Testing sub-classing
  def test_creating_subclasses
    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    # In fOOrth ==> class: MyClass
    #        or ==> Object subclass: MyClass
    my_class = XfOOrth.object_class.create_foorth_subclass("MyClass")

    assert_equal(XfOOrth.object_class.foorth_child_classes["MyClass"], my_class)
    assert_equal(my_class, XfOOrth.all_classes["MyClass"])
    assert_equal(my_class.name, "MyClass")
    assert_equal(my_class.foorth_class, XfOOrth.class_class)
    assert_equal(my_class.foorth_parent, XfOOrth.object_class)

    # In fOOrth ==> MyClass .new inst1 !
    inst1 = my_class.create_foorth_instance(vm)
    assert_equal(inst1.foorth_class.name, 'MyClass')
    assert_equal(inst1.name, 'MyClass instance')

    # In fOOrth ==> MyClass subclass: Other
    other = my_class.create_foorth_subclass("Other")

    assert_equal(my_class.foorth_child_classes["Other"], other)
    assert_equal(other, XfOOrth.all_classes["Other"])
    assert_equal(other.name, "Other")
    assert_equal(other.foorth_class, XfOOrth.class_class)
    assert_equal(other.foorth_parent, my_class)

    # In fOOrth ==> Other .new inst2 !
    inst2 = other.create_foorth_instance(vm)

    assert(inst1 != inst2)
    assert_equal(inst2.foorth_class.name, 'Other')
    assert_equal(inst2.name, 'Other instance')
  end

  #Test the the VM class does NOT sub-class
  def test_that_the_VM_class_does_not_subclass
    assert_raises(XfOOrth::XfOOrthError) do
      XfOOrth::VirtualMachine.create_foorth_subclass("MyClass")
    end
  end

  #Test sending a method to an object. Namely the class method to the
  #fOOrth Object class.
  def test_sending_a_method_to_a_class
    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    #Construct the source code for our code block.
    cs = XfOOrth::SymbolMap.map('.class')

    # In fOOrth ==> Object .class
    src = "lambda {|vm| vm.push(XfOOrth.object_class); vm.pop.#{cs}(vm); }"

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
    src = "lambda {|vm| vm.push(vm); vm.pop.#{cs}(vm); }"

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
    spec_4 = XfOOrth::MethodWordSpec.new('foo', :foo, [], &lambda {|vm| vm.push(4)})
    XfOOrth.object_class.add_shared_method(:foo, spec_4)

    vm.push(inst1)
    vm.instance_exec(vm, &blk)
    assert_equal(4, vm.pop)

    vm.push(inst2)
    vm.instance_exec(vm, &blk)
    assert_equal(4, vm.pop)

    # In fOOrth ==> Object :: foo 5 ;
    spec_5 = XfOOrth::MethodWordSpec.new('foo', :foo, [], &lambda {|vm| vm.push(5)})
    XfOOrth.object_class.add_shared_method(:foo, spec_5)

    vm.push(inst1)
    vm.instance_exec(vm, &blk)
    assert_equal(5, vm.pop)

    vm.push(inst2)
    vm.instance_exec(vm, &blk)
    assert_equal(5, vm.pop)

    # In fOOrth ==> TestClass :: foo 6 ;
    spec_6 = XfOOrth::MethodWordSpec.new('foo', :foo, [], &lambda {|vm| vm.push(6)})
    test_class.add_shared_method(:foo, spec_6)

    blk = lambda {|vm| vm.pop.foo(vm) }

    vm.push(inst1)
    vm.instance_exec(vm, &blk)
    assert_equal(5, vm.pop)

    vm.push(inst2)
    vm.instance_exec(vm, &blk)
    assert_equal(6, vm.pop)

    # In fOOrth ==> Object :: foo 7 ;
    spec_7 = XfOOrth::MethodWordSpec.new('foo', :foo, [], &lambda {|vm| vm.push(7)})
    XfOOrth.object_class.add_shared_method(:foo, spec_7)

    blk = lambda {|vm| vm.pop.foo(vm) }

    vm.push(inst1)
    vm.instance_exec(vm, &blk)
    assert_equal(7, vm.pop)

    vm.push(inst2)
    vm.instance_exec(vm, &blk)
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
    spec_11 = XfOOrth::MethodWordSpec.new('bar', :bar, [], &lambda {|vm| vm.push(11)})
    XfOOrth.object_class.add_shared_method(:bar, spec_11)

    vm.push(inst1)
    vm.instance_exec(vm, &blk)
    assert_equal(11, vm.pop)

    vm.push(inst2)
    vm.instance_exec(vm, &blk)
    assert_equal(11, vm.pop)

    # In fOOrth ==> inst2 @ ::: bar 22 ;
    spec_22 = XfOOrth::MethodWordSpec.new('bar', :bar, [], &lambda {|vm| vm.push(22)})
    inst2.add_exclusive_method(:bar, spec_22)

    vm.push(inst1)
    vm.instance_exec(vm, &blk)
    assert_equal(11, vm.pop)

    vm.push(inst2)
    vm.instance_exec(vm, &blk)
    assert_equal(22, vm.pop)

    # In fOOrth ==> Object :: bar 33 ;
    spec_33 = XfOOrth::MethodWordSpec.new('bar', :bar, [], &lambda {|vm| vm.push(33)})
    XfOOrth.object_class.add_shared_method(:bar, spec_33)

    vm.push(inst1)
    vm.instance_exec(vm, &blk)
    assert_equal(33, vm.pop)

    vm.push(inst2)
    vm.instance_exec(vm, &blk)
    assert_equal(22, vm.pop)
  end

  #Test that the children of Object class are set up correctly.
  def test_object_children
    children = XfOOrth.object_class.foorth_child_classes

    assert_equal(children['Class'], XfOOrth.class_class)
    assert_equal(children['VirtualMachine'], XfOOrth::VirtualMachine)
  end

  #Test the core method .is_class?
  def test_the_dot_is_class_qm_method
    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    # In fOOrth ==> Object .new inst1 !
    inst1 = XfOOrth.object_class.create_foorth_instance(vm)

    #Test the fOOrth code: Object .is_class?  ==> true
    src = "lambda {|vm| "
    sym = XfOOrth::SymbolMap.map("Object")
    spec = XfOOrth.object_class.map_foorth_shared(sym)
    src << spec.builds("Object")
    sym = XfOOrth::SymbolMap.map(".is_class?")
    spec = XfOOrth.object_class.map_foorth_shared(sym)
    src << spec.builds(".is_class?")
    src << "}"
    blk = eval src

    vm.instance_exec(vm, &blk)
    assert(vm.pop?) #Yup!

    #Test the fOOrth code: inst1 @ .is_class?  ==> false
    src = "lambda {|vm| "
    src << "vm.push(inst1); "  #Punt for now.
    sym = XfOOrth::SymbolMap.map(".is_class?")
    spec = XfOOrth.object_class.map_foorth_shared(sym)
    src << spec.builds(".is_class?")
    src << "}"
    blk = eval src

    vm.instance_exec(vm, &blk)
    refute(vm.pop?) #Nope!
  end

  #Testing virtual machine method redefinition
  def test_vm_method_redefining
    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    XfOOrth.object_class.create_shared_method('.test', XfOOrth::MethodWordSpec, [],
      &lambda {|vm| vm.push(42)})

    src = "lambda {|vm| vm.push(vm); "
    sym = XfOOrth::SymbolMap.map(".test")
    spec = XfOOrth::VirtualMachine.map_foorth_shared(sym)
    src << spec.builds(".test")
    src << "}"
    blk = eval src

    vm.instance_exec(vm, &blk)
    assert_equal(vm.pop, 42)

    XfOOrth::VirtualMachine.create_shared_method('.test', XfOOrth::MethodWordSpec, [],
      &lambda {|vm| vm.push(69)})

    vm.instance_exec(vm, &blk)
    assert_equal(vm.pop, 69)

    vm.create_exclusive_method('.test', XfOOrth::MethodWordSpec, [],
      &lambda {|vm| vm.push(109)})

    vm.instance_exec(vm, &blk)
    assert_equal(vm.pop, 109)
  end

  #Test out some macro methods.
  def test_some_macro_methods
    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    #Test the fOOrth code: self  ==> vm
    src = "lambda {|vm| "
    name = 'self'
    sym = XfOOrth::SymbolMap.map(name)
    spec = XfOOrth.object_class.map_foorth_shared(sym)
    src << spec.builds(name)
    src << "}"
    blk = eval src

    vm.instance_exec(vm, &blk)
    assert_equal(vm.pop, vm)

    #Test the fOOrth code: true  ==> true
    src = "lambda {|vm| "
    name = 'true'
    sym = XfOOrth::SymbolMap.map(name)
    spec = XfOOrth.object_class.map_foorth_shared(sym)
    src << spec.builds(name)
    src << "}"
    blk = eval src

    vm.instance_exec(vm, &blk)
    assert_equal(vm.pop, true)

    #Test the fOOrth code: false  ==> false
    src = "lambda {|vm| "
    name = 'false'
    sym = XfOOrth::SymbolMap.map(name)
    spec = XfOOrth.object_class.map_foorth_shared(sym)
    src << spec.builds(name)
    src << "}"
    blk = eval src

    vm.instance_exec(vm, &blk)
    assert_equal(vm.pop, false)

    #Test the fOOrth code: false  ==> false
    src = "lambda {|vm| "
    name = 'nil'
    sym = XfOOrth::SymbolMap.map(name)
    spec = XfOOrth.object_class.map_foorth_shared(sym)
    src << spec.builds(name)
    src << "}"
    blk = eval src

    vm.instance_exec(vm, &blk)
    assert_equal(vm.pop, nil)

    #Test the fOOrth code: ~name  ==> "VirtualMachine instance <Main>."
    src = "lambda {|vm| "
    name = '~name'
    sym = XfOOrth::SymbolMap.map(name)
    spec = XfOOrth.object_class.map_foorth_shared(sym)
    src << spec.builds(name)
    src << "}"
    blk = eval src

    vm.instance_exec(vm, &blk)
    assert_equal(vm.pop, "VirtualMachine instance <Main>.")

  end

end
