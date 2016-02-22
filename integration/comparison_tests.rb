# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class ComparisonTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  include MinitestVisible

  def test_greater_than
   foorth_raises("Object .new 4 > ")
  end

  def test_max_and_min
    foorth_equal("4    2   max", [4])

    foorth_equal("4    2   min", [2])

    foorth_equal('"4" "2"  max', ["4"])
    foorth_equal('"4" "2"  min', ["2"])
  end

  def test_more_holistically
    foorth_equal("[ 2 4 -2 1/2 555 8 -33 17 ] val$: $tmw", [])

    foorth_equal("infinity  $tmw .each{{ v min }}  ", [-33])
    foorth_equal("-infinity $tmw .each{{ v max }}  ", [555])
  end

  def test_greater_than
    foorth_equal('4       4       >  ', [false])
    foorth_equal('4       5       >  ', [false])
    foorth_equal('5       4       >  ', [true])

    foorth_equal('"4"       "4"   >  ', [false])
    foorth_equal('"4"       4     >  ', [false])
    foorth_equal('"4"       "5"   >  ', [false])
    foorth_equal('"4"       5     >  ', [false])
    foorth_equal('"5"       "4"   >  ', [true])
    foorth_equal('"5"       4     >  ', [true])
  end

  def test_less_than
    foorth_equal('4       4       <  ', [false])
    foorth_equal('4       5       <  ', [true])
    foorth_equal('5       4       <  ', [false])

    foorth_equal('"4"       "4"   <  ', [false])
    foorth_equal('"4"       4     <  ', [false])
    foorth_equal('"4"       "5"   <  ', [true])
    foorth_equal('"4"       5     <  ', [true])
    foorth_equal('"5"       "4"   <  ', [false])
    foorth_equal('"5"       4     <  ', [false])
  end

  def test_greater_or_equal
    foorth_equal('4       4       >= ', [true])
    foorth_equal('4       5       >= ', [false])
    foorth_equal('5       4       >= ', [true])

    foorth_equal('"4"       "4"   >= ', [true])
    foorth_equal('"4"       4     >= ', [true])
    foorth_equal('"4"       "5"   >= ', [false])
    foorth_equal('"4"       5     >= ', [false])
    foorth_equal('"5"       "4"   >= ', [true])
    foorth_equal('"5"       4     >= ', [true])
  end

  def test_less_or_equal
    foorth_equal('4       4       <= ', [true])
    foorth_equal('4       5       <= ', [true])
    foorth_equal('5       4       <= ', [false])

    foorth_equal('"4"       "4"   <= ', [true])
    foorth_equal('"4"       4     <= ', [true])
    foorth_equal('"4"       "5"   <= ', [true])
    foorth_equal('"4"       5     <= ', [true])
    foorth_equal('"5"       "4"   <= ', [false])
    foorth_equal('"5"       4     <= ', [false])
  end

  def test_the_compare_operator
    foorth_equal('4       4       <=>', [0])
    foorth_equal('4       5       <=>', [-1])
    foorth_equal('5       4       <=>', [1])

    foorth_equal('"4"       "4"   <=>', [0])
    foorth_equal('"4"       4     <=>', [0])
    foorth_equal('"4"       "5"   <=>', [-1])
    foorth_equal('"4"       5     <=>', [-1])
    foorth_equal('"5"       "4"   <=>', [1])
    foorth_equal('"5"       4     <=>', [1])
  end

  def test_some_comparisons_with_zero
    foorth_equal('-2       0=  ', [false])
    foorth_equal('0        0=  ', [true])
    foorth_equal('4        0=  ', [false])

    foorth_equal('-4       0<> ', [true])
    foorth_equal('0        0<> ', [false])
    foorth_equal('5        0<> ', [true])

    foorth_equal('-1       0>  ', [false])
    foorth_equal('0        0>  ', [false])
    foorth_equal('4        0>  ', [true])

    foorth_equal('4        0<  ', [false])
    foorth_equal('-5       0<  ', [true])
    foorth_equal('0        0<  ', [false])

    foorth_equal('4        0>= ', [true])
    foorth_equal('-5       0>= ', [false])
    foorth_equal('0        0>= ', [true])

    foorth_equal('-4       0<= ', [true])
    foorth_equal('0        0<= ', [true])
    foorth_equal('4        0<= ', [false])

    foorth_equal('0        0<=>', [0])
    foorth_equal('-5       0<=>', [-1])
    foorth_equal('4        0<=>', [1])
  end

end
