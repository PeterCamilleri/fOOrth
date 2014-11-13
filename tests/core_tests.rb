# coding: utf-8

$exclude_fOOrth_library = true
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

  def test_that_object_handles_no_method_errors
    #Get an object instance to test with.
    obj = Object.new

    assert_raises(XfOOrth::XfOOrthError) do
      obj.foorth_init
    end

    assert_raises(NoMethodError) do
      obj.qwertyuiop
    end
  end

  def test_that_shared_methods_can_be_defined
    #Get an object instance to test with.
    obj = Object.new

    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    XfOOrth::SymbolMap.add_entry("a_test_one", :a_test_one)

    spec = Object.create_shared_method("a_test_one", XfOOrth::PublicWordSpec, []) {|vm| vm.push(9671111) }

    obj.a_test_one(vm)

    assert_equal(9671111, vm.pop)
    assert_equal(spec, Object.map_foorth_shared(:a_test_one))
    assert_equal(spec, Class.map_foorth_shared(:a_test_one))
    assert_equal(spec, Object.foorth_shared[:a_test_one])
    assert_equal(nil,  Class.foorth_shared[:a_test_one])
  end

  def test_that_exclusive_methods_can_be_defined
    #Get an object instance to test with.
    obj = Object.new

    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    XfOOrth::SymbolMap.add_entry("a_test_two", :a_test_two)

    spec = obj.create_exclusive_method("a_test_two", XfOOrth::PublicWordSpec, []) do |vm|
      vm.push(9686668)
    end

    obj.a_test_two(vm)

    assert_equal(9686668, vm.pop)
    assert_equal(spec, obj.map_foorth_exclusive(:a_test_two))
    assert_equal(spec, obj.foorth_exclusive[:a_test_two])
    assert_equal(nil, Object.map_foorth_shared(:a_test_two))
    assert_equal(nil, Class.map_foorth_shared(:a_test_two))
  end

# Core Tsunami -- Most of what follows will be swept away... eventually...

  #Test out the bare minimum core elements
  def test_core_essentials
    assert_equal(XfOOrth.object_class.foorth_name, "Object")
    assert_equal(XfOOrth.class_class.foorth_name,  "Class")
    assert_equal(XfOOrth::VirtualMachine.foorth_name,  "VirtualMachine")

    assert_equal(XfOOrth.object_class.foorth_parent, nil)
    assert_equal(XfOOrth.class_class.foorth_parent.foorth_name, "Object")
    assert_equal(XfOOrth::VirtualMachine.foorth_parent.foorth_name, "Object")

    assert_equal(XfOOrth.object_class.foorth_class.foorth_name, "Class")
    assert_equal(XfOOrth.class_class.foorth_class.foorth_name, "Class")
    assert_equal(XfOOrth::VirtualMachine.foorth_class.foorth_name, "Class")

    assert_equal(XfOOrth.object_class.foorth_child_classes["Class"].foorth_name, "Class")
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
    assert_equal(inst1.foorth_class.foorth_name, 'Object')
    assert_equal(inst1.foorth_name, 'Object instance')

    inst2 = XfOOrth.object_class.create_foorth_instance(vm)
    assert(inst1 != inst2)
    assert_equal(inst1.class, inst2.class)
    assert_equal(inst1.foorth_class, inst2.foorth_class)
  end

  #Test that VM instances behave too.
  def test_vm_instances
    vm = XfOOrth.virtual_machine
    assert_equal(vm.foorth_name, "VirtualMachine instance <Main>")
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

  def test_proxy_classes
    XfOOrth.create_proxy(Numeric,  XfOOrth.object_class)
    XfOOrth.create_proxy(Integer,  Numeric)
    XfOOrth.create_proxy(Fixnum,   Integer)

    assert_equal('Numeric', Numeric.foorth_name)
    assert_equal('Integer', Integer.foorth_name)
    assert_equal('Fixnum',  Fixnum.foorth_name)

    assert_equal(XfOOrth.object_class, Numeric.foorth_parent)
    assert_equal(Numeric, Integer.foorth_parent)
    assert_equal(Integer, Fixnum.foorth_parent)

    assert_equal('Fixnum instance',  (42).foorth_name)
  end

  def test_missing_method_handling
    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    sym = XfOOrth::SymbolMap.add_entry("tmmh", :tmmh)

    assert_raises(XfOOrth::XfOOrthError) do
      XfOOrth.object_class.tmmh
    end

    assert_raises(NoMethodError) do
      XfOOrth.object_class.cranch  #Scanners live in vain!
    end

    sym = XfOOrth::SymbolMap.add_entry(".semper", :tmmh_deux)
    XfOOrth.object_class.create_shared_method('.semper', XfOOrth::PublicWordSpec, [])
    inst1 = XfOOrth.object_class.create_foorth_instance(vm)

    assert_raises(XfOOrth::XfOOrthError) do
      XfOOrth.object_class.tmmh_deux(vm)
    end

  end

  def test_creating_subclasses
    a_class = XfOOrth.object_class.create_foorth_subclass("AClass")
    assert_equal('AClass', a_class.foorth_name)
    assert_equal('Object', a_class.foorth_parent.foorth_name)
    assert_equal('Class', a_class.foorth_class.foorth_name)

    b_class = a_class.create_foorth_subclass("BClass")
    assert_equal('BClass', b_class.foorth_name)
    assert_equal('AClass', b_class.foorth_parent.foorth_name)
    assert_equal('Class', b_class.foorth_class.foorth_name)


    c_class = XfOOrth.class_class.create_foorth_subclass("CClass")
    assert_equal('CClass', c_class.foorth_name)
    assert_equal('Class', c_class.foorth_parent.foorth_name)
    assert_equal('Class', c_class.foorth_class.foorth_name)

    d_class = c_class.create_foorth_subclass("DClass", c_class)
    assert_equal('DClass', d_class.foorth_name)
    assert_equal('CClass', d_class.foorth_parent.foorth_name)
    assert_equal('CClass', d_class.foorth_class.foorth_name)

    e_class = XfOOrth.object_class.create_foorth_subclass("EClass", d_class)
    assert_equal('EClass', e_class.foorth_name)
    assert_equal('Object', e_class.foorth_parent.foorth_name)
    assert_equal('DClass', e_class.foorth_class.foorth_name)
  end

end
