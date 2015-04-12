# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class ExceptionLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_for_exception_patches
    assert_equal("E15: ZeroDivisionError", ZeroDivisionError.new.foorth_message)
    assert_equal("F123: oops", XfOOrth::XfOOrthError.new("F123: oops").foorth_message)
    assert_equal("A123: oh oh", XfOOrth::XfOOrthError.new("A123: oh oh").foorth_message)

    assert(ZeroDivisionError.new.foorth_match('E'))
    assert(ZeroDivisionError.new.foorth_match('E1'))
    assert(ZeroDivisionError.new.foorth_match('E15'))

    refute(ZeroDivisionError.new.foorth_match('F'))
    refute(ZeroDivisionError.new.foorth_match('E2'))
    refute(ZeroDivisionError.new.foorth_match('E12'))
    refute(ZeroDivisionError.new.foorth_match('E1501'))

    assert_equal("E??:" , Exception.new.foorth_code)
    assert_equal("E:"   , StandardError.new.foorth_code)
    assert_equal("E15:" , ZeroDivisionError.new.foorth_code)
    assert_equal("F12,33:", XfOOrth::XfOOrthError.new("F12,33: oops").foorth_code)
    assert_equal("A12,93:", XfOOrth::XfOOrthError.new("A12,93: oh oh").foorth_code)
    assert_equal("E12,E2BIG:", Errno::E2BIG.new.foorth_code)
    assert_equal("S:",    SignalException.new("INT").foorth_code)
    assert_equal("S01:" , Interrupt.new.foorth_code)
  end

  def test_for_try_blocks
    foorth_equal('try 5 end', [5])
  end

  def test_for_try_catch
    foorth_equal('try 5 0 + catch drop 6 end ', [5])
    foorth_equal('try 5 0 / catch drop 6 end ', [6])
    foorth_equal('try 5 0 / catch drop error end ', ["E15: divided by 0"])
  end

  def test_for_exception_methods
    foorth_equal('try 5 0 / catch drop ?"E15" if 0 then end ', [0])
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

  def test_for_error_bouncing
    foorth_run(': test_bounce try  .ceil catch ?"E15" if "WTF?" else bounce then end ;')
    foorth_equal('try 1+1i test_bounce catch "Got it!" end', ["Got it!"])
  end

  def test_raising_an_exception
    foorth_raises('"F99  Error!!!" .raise')
  end

end
