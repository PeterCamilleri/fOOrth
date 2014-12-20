# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class StandardLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_basic_constants
    foorth_equal("self", [Thread.current[:vm]])
    foorth_equal("true", [true])
    foorth_equal("false", [false])
    foorth_equal("nil", [nil])
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

    foorth_equal("1 2 nip", [2])
    foorth_raises("1 nip")

    foorth_equal("1 2 tuck", [2,1,2])
    foorth_raises("1 tuck")
    foorth_raises("tuck")
  end

  def test_for_the_bored_identity
    foorth_equal("33 33 identical?", [true])
    foorth_equal("33 33 distinct?", [false])

    foorth_equal('"33" "33" identical?', [false])
    foorth_equal('"33" "33" distinct?', [true])

    foorth_equal('"33" dup  identical?', [true])
    foorth_equal('"33" dup  distinct?', [false])

  end

  def test_some_cloning_around
    foorth_equal("33 clone", [33,33])
    foorth_equal("33 .clone", [33])

    foorth_equal("33 clone identical?", [true])
    foorth_equal("33 clone distinct?", [false])

    foorth_equal('"33" clone identical?', [false])
    foorth_equal('"33" clone distinct?', [true])

    foorth_equal('"33" dup .clone identical?', [false])
    foorth_equal('"33" dup .clone distinct?', [true])
  end

  def test_some_logical_ops
    foorth_equal("false false &&", [false])
    foorth_equal("false true  &&", [false])
    foorth_equal("true  false &&", [false])
    foorth_equal("true  true  &&", [true ])

    foorth_equal("false false ||", [false])
    foorth_equal("false true  ||", [true ])
    foorth_equal("true  false ||", [true ])
    foorth_equal("true  true  ||", [true ])

    foorth_equal("false false ^^", [false])
    foorth_equal("false true  ^^", [true ])
    foorth_equal("true  false ^^", [true ])
    foorth_equal("true  true  ^^", [false])

    foorth_equal("false not", [true ])
    foorth_equal("true  not", [false])
  end

end
