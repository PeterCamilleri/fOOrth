# coding: utf-8

$exclude_fOOrth_library = true
require_relative '../lib/fOOrth'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class CoreTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def test_that_object_handles_no_method_errors
    #Get an object instance to test with.
    obj = Object.new

    XfOOrth::SymbolMap.add_entry("a_test_zero", :a_test_zero)

    assert_raises(XfOOrth::XfOOrthError) do
      obj.a_test_zero
    end

    assert_raises(NoMethodError) do
      obj.qwertyuiop
    end
  end

  def test_that_shared_methods_can_be_defined
    #Get an object instance to test with.
    obj = Object.new

    #Get the virtual machine.
    vm = Thread.current[:vm]

    XfOOrth::SymbolMap.add_entry("a_test_one", :a_test_one)

    spec = Object.create_shared_method("a_test_one", XfOOrth::TosSpec, []) {|lvm| lvm.push(9671111) }

    obj.a_test_one(vm)

    assert_equal(9671111, vm.pop)
    assert_equal(spec, Object.map_foorth_shared(:a_test_one))
    assert_equal(spec, Class.map_foorth_shared(:a_test_one))
    assert_equal(spec, Object.foorth_shared[:a_test_one])
    assert_nil(Class.foorth_shared[:a_test_one])
  end

  def test_that_exclusive_methods_can_be_defined
    #Get an object instance to test with.
    obj = Object.new

    #Get the virtual machine.
    vm = XfOOrth::VirtualMachine.vm

    XfOOrth::SymbolMap.add_entry("a_test_two", :a_test_two)

    spec = obj.create_exclusive_method("a_test_two", XfOOrth::TosSpec, []) do |lvm|
      lvm.push(9686668)
    end

    obj.a_test_two(vm)

    assert_equal(9686668, vm.pop)
    assert_equal(spec, obj.map_foorth_exclusive(:a_test_two))
    assert_equal(spec, obj.foorth_exclusive[:a_test_two])
    assert_nil(Object.map_foorth_shared(:a_test_two))
    assert_nil(Class.map_foorth_shared(:a_test_two))
  end

  def test_class_naming
    assert_equal("Object",         Object.foorth_name)
    assert_equal("Class",          Class.foorth_name)
    assert_equal("VirtualMachine", XfOOrth::VirtualMachine.foorth_name)

    vm = Thread.current[:vm]
    assert_equal("VirtualMachine instance <Main>", vm.foorth_name)
  end

  def test_instance_naming
    obj = Object.new
    assert_equal("Object instance", obj.foorth_name)

    vm = Thread.current[:vm]
    assert_equal("VirtualMachine instance <Main>", vm.foorth_name)
  end

  def test_that_virtual_machine_rejects_new
    assert_raises(XfOOrth::XfOOrthError) do
      XfOOrth::VirtualMachine.new('Fails')
    end
  end

  def test_that_the_VM_class_does_not_subclass
    assert_raises(XfOOrth::XfOOrthError) do
      XfOOrth::VirtualMachine.create_foorth_subclass("MyClass")
    end
  end

  def test_creating_subclasses
    new_class = Object.create_foorth_subclass('MyClass')
    symbol = XfOOrth::SymbolMap.map('MyClass')

    assert($FOORTH_GLOBALS[symbol])
    assert_equal('ClassSpec instance', new_class.foorth_name)
    assert_equal(XfOOrth::XfOOrth_MyClass, new_class.new_class)
    assert_equal(XfOOrth::XfOOrth_MyClass, $FOORTH_GLOBALS[symbol].new_class)

    assert_raises(XfOOrth::XfOOrthError) do
      Object.create_foorth_subclass('No Class')
    end

    assert_raises(XfOOrth::XfOOrthError) do
      Object.create_foorth_subclass('MyClass')
    end
  end

  def test_creating_proxies
    new_proxy = String.create_foorth_proxy
    symbol = XfOOrth::SymbolMap.map('String')

    assert($FOORTH_GLOBALS[symbol])
    assert_equal('String', new_proxy.new_class.foorth_name)
    assert_equal(String, new_proxy.new_class)
    assert_equal(String, $FOORTH_GLOBALS[symbol].new_class)

    assert_raises(XfOOrth::XfOOrthError) do
      Object.create_foorth_subclass('My Class')
    end

    assert_raises(XfOOrth::XfOOrthError) do
      Module.create_foorth_proxy('Mod ule')
    end

  end

end
