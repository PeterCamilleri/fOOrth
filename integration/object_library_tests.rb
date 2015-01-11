# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class ObjectLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

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

end
