# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class InStreamLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_that_class_exists
    foorth_equal('InStream',       [XfOOrth::XfOOrth_InStream])
    foorth_equal('InStream .name', ['InStream'])
  end

  def test_that_new_is_a_stub
    foorth_raises('InStream .new')
  end

  def test_opening_and_reading
    foorth_equal('"integration/in_stream_test_1.txt" InStream .open dup .gets swap .close', ['Test 1 2 3'])
    foorth_equal('"integration/in_stream_test_1.txt" InStream .open dup .getc swap .close', ['T'])
  end
end
