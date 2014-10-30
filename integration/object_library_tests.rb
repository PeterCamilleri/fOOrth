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
    foorth_equal("Object", [XfOOrth.object_class])
  end

  def test_getting_a_things_name
    foorth_equal("Object .name",      ['Object'])
    foorth_equal("Class  .name",      ['Class'])

    foorth_equal("Object .new .name", ['Object instance'])
    foorth_equal("45          .name", ['Fixnum instance'])
    foorth_equal('"Foobar"    .name', ['String instance'])
  end

end
