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

  def test_for_exception_patches
    assert_equal("E"   , StandardError.new.foorth_code)
    assert_equal("E150", ZeroDivisionError.new.foorth_code)
    assert_equal("E120,E2BIG", Errno::E2BIG.new.foorth_code)
    assert_equal("Fxxx", XfOOrth::XfOOrthError.new.foorth_code)
    assert_equal("F123", XfOOrth::XfOOrthError.new("F123: oops").foorth_code)
    assert_equal("A123", XfOOrth::XfOOrthError.new("A123: oh oh").foorth_code)
    assert_equal("S",    SignalException.new("INT").foorth_code)
    assert_equal("S010", Interrupt.new.foorth_code)

    assert_equal("E150: ZeroDivisionError", ZeroDivisionError.new.foorth_message)
    assert_equal("F123: oops", XfOOrth::XfOOrthError.new("F123: oops").foorth_message)
    assert_equal("A123: oh oh", XfOOrth::XfOOrthError.new("A123: oh oh").foorth_message)

    assert(ZeroDivisionError.new.foorth_match('E'))
    assert(ZeroDivisionError.new.foorth_match('E1'))
    assert(ZeroDivisionError.new.foorth_match('E15'))
    assert(ZeroDivisionError.new.foorth_match('E150'))

    refute(ZeroDivisionError.new.foorth_match('F'))
    refute(ZeroDivisionError.new.foorth_match('E2'))
    refute(ZeroDivisionError.new.foorth_match('E12'))
    refute(ZeroDivisionError.new.foorth_match('E151'))
    refute(ZeroDivisionError.new.foorth_match('E1501'))

    assert_equal("Exception instance <E>"   , StandardError.new.foorth_name)
    assert_equal("Exception instance <E150>", ZeroDivisionError.new.foorth_name)
    assert_equal("Exception instance <F123>", XfOOrth::XfOOrthError.new("F123: oops").foorth_name)
    assert_equal("Exception instance <A123>", XfOOrth::XfOOrthError.new("A123: oh oh").foorth_name)
    assert_equal("Exception instance <E120,E2BIG>", Errno::E2BIG.new.foorth_name)
    assert_equal("Exception instance <S>",    SignalException.new("INT").foorth_name)
    assert_equal("Exception instance <S010>", Interrupt.new.foorth_name)
  end

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

  def test_for_exception_methods
    foorth_equal('try 5 0 / catch drop ?"E150" if 0 then end ', [0])
  end

  def test_with_finally
    foorth_equal('try 5 0 + drop catch drop finally "apple" end', ["apple"])
    foorth_equal('try 5 0 / drop catch drop finally "apple" end', ["apple"])
  end

  def test_for_bad_constructs_errors
    foorth_raises('try 5 0 / catch drop 6 catch ."YA!" end ')
    foorth_raises('try 5 0 / finally drop 6 finally ."YA!" end ')
    foorth_raises('try 5 0 / catch drop 6 finally error   ."YA!" end ')
    foorth_raises('try 5 0 / catch drop 6 finally ?"E150" ."YA!" end ')

  end

  def test_for_error_error
    foorth_raises('try 5 0 error end')
  end

end
