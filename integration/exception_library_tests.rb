# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class ArrayLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_for_try_blocks
    foorth_equal('try{ 5 } ', [5])

  end

  def test_for_try_catch
    foorth_equal('try{ 5 0 + catch drop 6 } ', [5])
    foorth_equal('try{ 5 0 / catch drop 6 } ', [6])

  end

  def test_for_multi_catch_error
    foorth_raises('try{ 5 0 / catch drop 6 catch ."YA!" } ')
  end

end