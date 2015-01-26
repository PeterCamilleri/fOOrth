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

  $isfn = '"integration/in_stream_test_1.txt" '

  def test_that_class_exists
    foorth_equal('InStream',       [XfOOrth::XfOOrth_InStream])
    foorth_equal('InStream .name', ['InStream'])
  end

  def test_that_new_is_a_stub
    foorth_raises('InStream .new')
  end

  def test_opening_and_reading_a_character
    foorth_equal($isfn + 'InStream .open dup .getc swap .close', ['T'])
  end

  def test_opening_and_reading_a_line
    foorth_equal($isfn + 'InStream .open dup .gets swap .close', ['Test 1 2 3'])
  end

  def test_open_block_and_reading_a_character
    foorth_equal($isfn + 'InStream .open{ ~getc }', ['T'])
  end

  def test_open_block_and_reading_a_line
    foorth_equal($isfn + 'InStream .open{ ~gets }', ['Test 1 2 3'])
  end


  def test_opening_and_reading_all_lines
    all_lines = ["Test 1 2 3",
                 "Test 4 5 6",
                 "ABCDEFG",
                 "Eric the Half a Bee"]

    foorth_equal($isfn + 'InStream .get_all', [all_lines])
  end


end
