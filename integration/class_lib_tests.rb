# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class ClassLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  include MinitestVisible

  def test_that_the_class_class_is_available
    foorth_equal("Class", [Class])
  end

  def test_that_we_can_tell_classes_from_non_classes
    foorth_equal("Class  .is_class?",      [true])
    foorth_equal("Object .is_class?",      [true])
    foorth_equal("Object .new .is_class?", [false])

    foorth_equal("Numeric .is_class?",     [true])
    foorth_equal("42      .is_class?",     [false])
  end

  def test_that_we_can_find_the_class_of_a_thing
    foorth_equal("Class       .class",     [Class])
    foorth_equal("Object      .class",     [Class])

    foorth_equal("Object .new .class",     [Object])
    foorth_equal("42          .class",     [Fixnum])
    foorth_equal('"foobar"    .class',     [String])
  end

  def test_that_we_can_find_the_parent_of_a_class
    foorth_equal("Class     .parent_class",   [Object])
    foorth_equal("Object    .parent_class",   [nil])

    foorth_run('class: TTWCFTPC')
    foorth_equal("TTWCFTPC .parent_class", [Object])
  end

  def test_the_creation_of_a_class
    foorth_equal("class: T1",        [])

    foorth_equal("T1",               [XfOOrth::XfOOrth_T1])
    foorth_equal("T1 .parent_class", [Object])
    foorth_equal("T1 .name",         ['T1'])
    foorth_equal("T1 .new .name",    ['T1 instance'])
  end

  def test_deferred_class_creation
    foorth_run(" true if class: T1B then ")
    foorth_equal("T1B .name", ["T1B"])
  end

  def test_deferred_subclass_creation
    foorth_run(" true if Object .subclass: T1C then ")
    foorth_equal("T1C .name", ["T1C"])
  end

  def test_the_creation_of_a_sub_class
    foorth_equal("class: T2",        [])
    foorth_equal("T2 .subclass: T3", [])

    foorth_equal("T3",               [XfOOrth::XfOOrth_T3])
    foorth_equal("T3 .parent_class", [XfOOrth::XfOOrth_T2])
    foorth_equal("T3 .name",         ['T3'])
    foorth_equal("T3 .new .name",    ['T3 instance'])
  end

  def test_creating_an_init_method
    foorth_equal("class: T4", [])
    foorth_equal("T4 .: .init 2 4 6 8 ;", [])

    foorth_equal("T4 .new .name", [2, 4, 6, 8, 'T4 instance'])
  end

  def test_creating_an_instance_var
    foorth_equal("class: T5", [])
    foorth_equal("T5 .: .init var@: @a ;", [])
    foorth_equal("T5 .: .a@ @a @ ;", [])

    foorth_equal("10 T5 .new .a@", [10])
  end

  def test_creating_an_accessor
    foorth_equal("class: T6", [])
    foorth_equal("T6 .: .init var@: @a ;", [])
    foorth_equal("T6 .: .a@ @a @ ;", [])
    foorth_equal("T6 .: .a! @a ! ;", [])

    foorth_equal("nil T6 .new dup 100 swap .a! .a@", [100])
  end

  def test_creating_an_instance_val
    foorth_equal("class: T7", [])
    foorth_equal("T7 .: .init val@: @a ;", [])
    foorth_equal("T7 .: .a@ @a ;", [])

    foorth_equal("10 T7 .new .a@", [10])
  end

  def test_the_checking_of_classes
    foorth_equal('12   Numeric .check', [12])
    foorth_equal('"12" Numeric .check', [nil])

    foorth_equal('12   Numeric .check!', [12])
    foorth_raises('"12" Numeric .check!')
  end

end
