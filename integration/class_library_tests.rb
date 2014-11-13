# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'

#Test the standard fOOrth library.
class ClassLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

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
    foorth_equal("Class  .parent_class",   [Module])
    foorth_equal("Object .parent_class",   [BasicObject])
  end

end
