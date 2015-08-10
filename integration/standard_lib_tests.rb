# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class StandardLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_basic_constants
    refute(Thread.current[:vm].nil?)

    foorth_equal("self",      [Thread.current[:vm]])
    foorth_equal("true",      [true])
    foorth_equal("false",     [false])
    foorth_equal("nil",       [nil])

    foorth_equal("epsilon",   [Float::EPSILON])
    foorth_equal("infinity",  [Float::INFINITY]) #and beyond...
    foorth_equal("-infinity", [-Float::INFINITY])
    foorth_equal("max_float", [Float::MAX])
    foorth_equal("min_float", [Float::MIN])
    foorth_equal("nan",       [Float::NAN])
  end

  def test_stack_manipulation
    foorth_equal("1 2", [1, 2])

    foorth_equal("1 2 drop", [1])
    foorth_raises("drop")

    foorth_equal("33 dup", [33,33])
    foorth_raises("dup")

    foorth_equal("false ?dup", [false])
    foorth_equal("nil ?dup", [nil])
    foorth_equal('"" ?dup', ["", ""])
    foorth_equal("true  ?dup", [true, true])
    foorth_equal('"A" ?dup', ["A", "A"])
    foorth_equal("1 ?dup", [1,1])
    foorth_raises("?dup")

    foorth_equal("1 2 swap", [2,1])
    foorth_raises("1 swap")
    foorth_raises("swap")

    foorth_equal("1 2 3 rot", [2,3,1])

    foorth_equal("1 2 over", [1,2,1])

    foorth_equal("1 2 3 1 pick", [1,2,3,3])
    foorth_equal("1 2 3 2 pick", [1,2,3,2])
    foorth_equal("1 2 3 3 pick", [1,2,3,1])
    foorth_raises("1 2 3 4 pick")
    foorth_raises("1 2 3 -4 pick")
    foorth_raises('1 2 3 "apple" pick')

    foorth_equal("1 2 nip", [2])
    foorth_raises("1 nip")

    foorth_equal("1 2 tuck", [2,1,2])
    foorth_raises("1 tuck")
    foorth_raises("tuck")
  end

  def test_the_double_stack_ops
    foorth_equal('1 2 2drop', [])
    foorth_equal('1 2 2dup', [1,2,1,2])

    foorth_raises('1 2drop')
    foorth_raises('1 2dup')
  end

  def test_for_the_bored_identity
    foorth_equal("33 33 identical?", [true])
    foorth_equal("33 33 distinct?", [false])

    foorth_equal('"33" "33" identical?', [false])
    foorth_equal('"33" "33" distinct?', [true])

    foorth_equal('"33" dup  identical?', [true])
    foorth_equal('"33" dup  distinct?', [false])

  end

  def test_dyadic_error_recovery
    #Insufficient parameters.
    foorth_equal('try       5 +   catch end', [])

    #Stub action.
    foorth_equal('try false 5 +   catch end', [])

    #Bad parameters.
    foorth_equal('try 5 false >   catch end', [])
    foorth_equal('try 5 false <   catch end', [])
    foorth_equal('try 5 false >=  catch end', [])
    foorth_equal('try 5 false <=  catch end', [])
    foorth_equal('try 5 false <=> catch end', [])
    foorth_equal('try 5 false +   catch end', [])
    foorth_equal('try 5 false -   catch end', [])
    foorth_equal('try 5 false *   catch end', [])
    foorth_equal('try 5 false **  catch end', [])
    foorth_equal('try 5 false /   catch end', [])
    foorth_equal('try 5 false mod catch end', [])

    foorth_equal('try now false >   catch end', [])
    foorth_equal('try now false <   catch end', [])
    foorth_equal('try now false >=  catch end', [])
    foorth_equal('try now false <=  catch end', [])
    foorth_equal('try now false <=> catch end', [])
    foorth_equal('try now false +   catch end', [])
    foorth_equal('try now false -   catch end', [])
    foorth_equal('try now false format catch end', [])

  end

  def test_some_logical_and
    foorth_equal("false false &&", [false])
    foorth_equal("false true  &&", [false])
    foorth_equal("true  false &&", [false])
    foorth_equal("true  true  &&", [true ])

    foorth_equal("nil   false &&", [false])
    foorth_equal("nil   true  &&", [false])
    foorth_equal("true  nil   &&", [false])
    foorth_equal("42    true  &&", [true ])
  end

  def test_some_logical_or
    foorth_equal("false false ||", [false])
    foorth_equal("false true  ||", [true ])
    foorth_equal("true  false ||", [true ])
    foorth_equal("true  true  ||", [true ])

    foorth_equal("nil   false ||", [false])
    foorth_equal("nil   true  ||", [true ])
    foorth_equal("true  nil   ||", [true ])
    foorth_equal("42    true  ||", [true ])
  end

  def test_some_logical_xor
    foorth_equal("false false ^^", [false])
    foorth_equal("false true  ^^", [true ])
    foorth_equal("true  false ^^", [true ])
    foorth_equal("true  true  ^^", [false])

    foorth_equal("nil   false ^^", [false])
    foorth_equal("nil   true  ^^", [true ])
    foorth_equal("true  nil   ^^", [true ])
    foorth_equal("42    true  ^^", [false])
  end

  def test_some_logical_not
    foorth_equal("false not", [true ])
    foorth_equal("true  not", [false])
  end

  def test_is_nil
    foorth_equal("false nil=", [false])
    foorth_equal("true  nil=", [false])
    foorth_equal("42    nil=", [false])
    foorth_equal("nil   nil=", [true])
  end

  def test_is_not_nil
    foorth_equal("false nil<>", [true])
    foorth_equal("true  nil<>", [true])
    foorth_equal("42    nil<>", [true])
    foorth_equal("nil   nil<>", [false])
  end


end
