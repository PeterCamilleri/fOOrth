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
  MinitestVisible.track self, __FILE__

  def test_greater_than
   foorth_raises("Object .new 4 > ")


  end

  def test_max_and_min
    foorth_equal("4       2       max", [4])
    foorth_equal("min_num 2       max", [2])
    foorth_equal("2       min_num max", [2])
    foorth_equal("max_num 2       max", [MaxNumeric])
    foorth_equal("2       max_num max", [MaxNumeric])

    foorth_equal("4       2       min", [2])
    foorth_equal("min_num 2       min", [MinNumeric])
    foorth_equal("2       min_num min", [MinNumeric])
    foorth_equal("max_num 2       min", [2])
    foorth_equal("2       max_num min", [2])

    foorth_equal('"4" "2"      max', ["4"])
    foorth_equal('"4" "2"      min', ["2"])
  end

  def test_more_holistically
    foorth_equal("[ 2 4 -2 1/2 555 8 -33 17 ] val$: $tmw", [])

    foorth_equal("max_num $tmw .each{ v min }  ", [-33])
    foorth_equal("min_num $tmw .each{ v max }  ", [555])
  end

  def test_greater_than
    foorth_equal('4       4       >  ', [false])
    foorth_equal('4       5       >  ', [false])
    foorth_equal('5       4       >  ', [true])
    foorth_equal('4       max_num >  ', [false])
    foorth_equal('max_num max_num >  ', [false])
    foorth_equal('min_num 4       >  ', [false])
    foorth_equal('4       min_num >  ', [true])
    foorth_equal('min_num min_num >  ', [false])
    foorth_equal('max_num min_num >  ', [true])
    foorth_equal('min_num max_num >  ', [false])

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
    foorth_equal('4       max_num <  ', [true])
    foorth_equal('max_num max_num <  ', [false])
    foorth_equal('min_num 4       <  ', [true])
    foorth_equal('4       min_num <  ', [false])
    foorth_equal('min_num min_num <  ', [false])
    foorth_equal('max_num min_num <  ', [false])
    foorth_equal('min_num max_num <  ', [true])

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
    foorth_equal('4       max_num >= ', [false])
    foorth_equal('max_num max_num >= ', [true])
    foorth_equal('min_num 4       >= ', [false])
    foorth_equal('4       min_num >= ', [true])
    foorth_equal('min_num min_num >= ', [true])
    foorth_equal('max_num min_num >= ', [true])
    foorth_equal('min_num max_num >= ', [false])

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
    foorth_equal('4       max_num <= ', [true])
    foorth_equal('max_num max_num <= ', [true])
    foorth_equal('min_num 4       <= ', [true])
    foorth_equal('4       min_num <= ', [false])
    foorth_equal('min_num min_num <= ', [true])
    foorth_equal('max_num min_num <= ', [false])
    foorth_equal('min_num max_num <= ', [true])

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
    foorth_equal('4       max_num <=>', [-1])
    foorth_equal('max_num max_num <=>', [0])
    foorth_equal('min_num 4       <=>', [-1])
    foorth_equal('4       min_num <=>', [1])
    foorth_equal('min_num min_num <=>', [0])
    foorth_equal('max_num min_num <=>', [1])
    foorth_equal('min_num max_num <=>', [-1])

    foorth_equal('"4"       "4"   <=>', [0])
    foorth_equal('"4"       4     <=>', [0])
    foorth_equal('"4"       "5"   <=>', [-1])
    foorth_equal('"4"       5     <=>', [-1])
    foorth_equal('"5"       "4"   <=>', [1])
    foorth_equal('"5"       4     <=>', [1])
  end

end
