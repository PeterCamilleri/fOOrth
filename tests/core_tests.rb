# coding: utf-8

require_relative '../lib/foorth/exceptions'
require_relative '../lib/foorth/symbol_map'
require_relative '../lib/foorth/core'
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
    assert_equal(Xfoorth::XClass.object_class.name, "Object")
    assert_equal(Xfoorth::XClass.class_class.name,  "Class")

    assert_equal(Xfoorth::XClass.object_class.foorth_parent, nil)
    assert_equal(Xfoorth::XClass.class_class.foorth_parent.name, "Object")

    assert_equal(Xfoorth::XClass.object_class.foorth_class.name, "Class")
    assert_equal(Xfoorth::XClass.class_class.foorth_class.name, "Class")

    assert_equal(Xfoorth::XClass.object_class.children["Class"].name, "Class")
    assert_equal(Xfoorth::XClass.class_class.children["Object"], nil)
  end

  #Test out some instances of Object
  def test_object_instances
    #No virtual machine to pass in at this point and it's not needed here.
    inst1 = Xfoorth::XClass.object_class.create_foorth_instance(nil)
    assert_equal(inst1.foorth_class.name, 'Object')
    assert_equal(inst1.name, 'Object instance.')

    inst2 = Xfoorth::XClass.object_class.create_foorth_instance(nil)
    assert(inst1 != inst2)
    assert_equal(inst1.class, inst2.class)
    assert_equal(inst1.foorth_class, inst2.foorth_class)
  end

end