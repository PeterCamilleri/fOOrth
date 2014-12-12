# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'

#Test the standard fOOrth library.
class ObjectLibraryTester < MiniTest::Unit::TestCase

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

  def test_that_the_object_class_is_available
    foorth_equal("Object", [Object])
  end

  def test_getting_a_things_name
    foorth_equal("Object .name",      ['Object'])
    foorth_equal("Class  .name",      ['Class'])

    foorth_equal("Object .new .name", ['Object instance'])
    foorth_equal("45          .name", ['Fixnum instance'])
    foorth_equal('"Foobar"    .name', ['String instance'])
  end

  def test_getting_an_object_as_a_string
    foorth_equal("4              .to_s", ['4'])
    foorth_equal("Object         .to_s", ['Object'])
    foorth_equal("VirtualMachine .to_s", ['VirtualMachine'])

    foorth_equal("4              .strlen", [1])
  end

  def test_max_and_min
    foorth_equal("4       2       max", [4])
    foorth_equal("min_num 2       max", [2])
    foorth_equal("2       min_num max", [2])
    foorth_equal("max_num 2       max", [MaxNumeric])
    foorth_equal("2       max_num max", [MaxNumeric])

    foorth_equal("4       2       min", [2])
    foorth_equal("min_num 2       min", [MinNumeric])
    foorth_equal("2       min_num min", [MinNumeric])
    foorth_equal("max_num 2       min", [2])
    foorth_equal("2       max_num min", [2])

    foorth_equal('"4" "2"      max', ["4"])
    foorth_equal('"4" "2"      min', ["2"])
  end

  def test_more_holistically
    foorth_equal("[ 2 4 -2 1/2 555 8 -33 17 ] global: $tmw", [])

    foorth_equal("max_num $tmw .each{ v min }  ", [-33])
    foorth_equal("min_num $tmw .each{ v max }  ", [555])
  end

end
