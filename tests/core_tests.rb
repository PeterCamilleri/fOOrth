# coding: utf-8

$exclude_fOOrth_library = true
gem              'minitest'
require          'minitest/autorun'
require_relative '../lib/fOOrth'

#Test the monkey patches applied to the Object class.
class CoreTester < MiniTest::Test

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


  #Test the the VM class does NOT sub-class
  def test_that_the_VM_class_does_not_subclass
    assert_raises(XfOOrth::XfOOrthError) do
      XfOOrth::VirtualMachine.create_foorth_subclass("MyClass")
    end
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
    spec_11 = XfOOrth::PublicWordSpec.new('.bar0', :bar, [], &lambda {|vm| vm.push(11)})
    XfOOrth.object_class.add_shared_method(:bar, spec_11)

    vm.push(inst1)
    vm.instance_exec(vm, &blk)
    assert_equal(11, vm.pop)

    vm.push(inst2)
    vm.instance_exec(vm, &blk)
    assert_equal(11, vm.pop)

    # In fOOrth ==> inst2 @ ::: bar 22 ;
    spec_22 = XfOOrth::PublicWordSpec.new('.bar0', :bar, [], &lambda {|vm| vm.push(22)})
    inst2.add_exclusive_method(:bar, spec_22)

    vm.push(inst1)
    vm.instance_exec(vm, &blk)
    assert_equal(11, vm.pop)

    vm.push(inst2)
    vm.instance_exec(vm, &blk)
    assert_equal(22, vm.pop)

    # In fOOrth ==> Object :: bar 33 ;
    spec_33 = XfOOrth::PublicWordSpec.new('.bar0', :bar, [], &lambda {|vm| vm.push(33)})
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

  #Testing virtual machine method redefinition
  def test_vm_method_redefining
    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    XfOOrth.object_class.create_shared_method('.test', XfOOrth::PublicWordSpec, [],
      &lambda {|vm| vm.push(42)})

    src = "lambda {|vm| vm.push(vm); "
    sym = XfOOrth::SymbolMap.map(".test")
    spec = XfOOrth::VirtualMachine.map_foorth_shared(sym)
    src << spec.builds()
    src << "}"
    blk = eval src

    vm.instance_exec(vm, &blk)
    assert_equal(vm.pop, 42)

    XfOOrth::VirtualMachine.create_shared_method('.test', XfOOrth::PublicWordSpec, [],
      &lambda {|vm| vm.push(69)})

    vm.instance_exec(vm, &blk)
    assert_equal(vm.pop, 69)

    vm.create_exclusive_method('.test', XfOOrth::PublicWordSpec, [],
      &lambda {|vm| vm.push(109)})

    vm.instance_exec(vm, &blk)
    assert_equal(vm.pop, 109)
  end

end
