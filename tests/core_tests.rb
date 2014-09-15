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

  #Test sending a method to an object. Namely the class method to the
  #fOOrth Object class.
  def test_sending_a_method_to_a_class
    #Get the virtual machine.
    vm = XfOOrth.virtual_machine

    #Construct the source code for our code block.
    cs = XfOOrth::SymbolMap.map('class')

    # In fOOrth ==> Object class
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
    cs = XfOOrth::SymbolMap.map('class')

    # In fOOrth ==> vm class
    src = "lambda \{|vm| vm.push(vm); vm.pop.#{cs}(vm); \}"

    #Create the block
    blk = eval src

    #Call the block
    blk.call(vm)

    #Test the results.
    assert_equal(XfOOrth::VirtualMachine, vm.pop)
  end

end