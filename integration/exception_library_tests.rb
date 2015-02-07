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

  def test_for_the_exception_class
    foorth_equal('Exception', [StandardError])
  end

  def test_for_try_blocks
    foorth_equal('try 5 end', [5])

  end

  def test_for_try_catch
    foorth_equal('try 5 0 + catch drop 6 end ', [5])
    foorth_equal('try 5 0 / catch drop 6 end ', [6])
    foorth_equal('try 5 0 / catch drop error .class end ', [ZeroDivisionError])

  end

  def test_for_multi_catch_error
    foorth_raises('try 5 0 / catch drop 6 catch ."YA!" end ')
  end

  def test_for_error_error
    foorth_raises('try 5 0 error end')
  end
end