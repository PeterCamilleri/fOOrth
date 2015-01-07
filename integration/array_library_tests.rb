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

  def test_some_array_basics
    foorth_equal('       Array                   ', [Array])

    foorth_equal('       Array .new              ', [[]])
    foorth_equal(': tt00 Array .new  ;           ', [])
    foorth_equal('tt00                           ', [[]])

    foorth_equal('       3 Array .new_size       ', [[0,0,0]])
    foorth_equal(': tt01 3 Array .new_size ;     ', [])
    foorth_equal('tt01                           ', [[0,0,0]])

    foorth_equal('       3 Array .new_value      ', [[3]])
    foorth_equal(': tt02 3 Array .new_value ;    ', [])
    foorth_equal('tt02                           ', [[3]])

    foorth_equal('       3 2 Array .new_values   ', [[3,3]])
    foorth_equal(': tt03 3 2 Array .new_values ; ', [])
    foorth_equal('tt03                           ', [[3,3]])

    foorth_equal('       3 Array .new{ x }       ', [[0,1,2]])
    foorth_equal(': tt04 3 Array .new{ x } ;     ', [])
    foorth_equal('tt04                           ', [[0,1,2]])

    foorth_equal('        [ 0 1 2 ]              ', [[0,1,2]])
    foorth_equal(': tt05  [ 0 1 2 ] ;            ', [])
    foorth_equal('tt05                           ', [[0,1,2]])

    foorth_equal('        [ 3 6 do i loop ]      ', [[3,4,5]])
    foorth_equal(': tt06  [ 3 6 do i loop ] ;    ', [])
    foorth_equal('tt06                           ', [[3,4,5]])
  end

  def test_arrays_in_variables
    foorth_equal('[ 3 6 9 ] global: $taiv1 ', [])
    foorth_equal('$taiv1                   ', [[3,6,9]])
  end

  def test_some_basic_operators
    foorth_equal('[ 3 6 9 ] [ 3 6 9 ]  = ', [true])
    foorth_equal('[ 3 6 9 ] [ 3 6 8 ]  = ', [false])

    foorth_equal('[ 3 6 9 ] [ 3 6 9 ]  <>', [false])
    foorth_equal('[ 3 6 9 ] [ 3 6 8 ]  <>', [true])

    foorth_equal('[ 3 6 9 ] [ 3 6 9 ] identical?', [false])
    foorth_equal('[ 3 6 9 ] [ 3 6 9 ] distinct?', [true])

    foorth_equal('[ 3 6 9 ] dup       identical?', [true])
    foorth_equal('[ 3 6 9 ] dup       distinct?', [false])

    foorth_equal('[ 3 6 9 ] clone     identical?', [false])
    foorth_equal('[ 3 6 9 ] clone     distinct?', [true])
  end

  def test_the_each
    foorth_equal('4 Array .new{ x 1 + dup * } global: $tte ', [])
    foorth_equal('$tte',                                      [[1,4,9,16]])

    foorth_equal('$tte .each{ x } ',                          [0,1,2,3])
    foorth_equal('$tte .each{ v } ',                          [1,4,9,16])

    foorth_equal(': tte $tte .each{ v } ;',                   [])
    foorth_equal('tte',                                       [1,4,9,16])
  end

  def test_the_map
    foorth_equal('[ 2 3 4 ] .map{ v 1+ }', [[3,4,5]])
  end

  def test_the_select
    foorth_equal('[ 0 10 do i loop ] .select{ v 1 and 0= }', [[0,2,4,6,8]])
  end

  def test_simple_array_indexing
    foorth_equal('4 Array .new{ x 1 + dup * } global: $tte ', [])
    foorth_equal('$tte',                                      [[1,4,9,16]])

    foorth_equal('$tte @ ',                                   [1])
    foorth_equal('10 $tte ! ',                                [])
    foorth_equal('$tte @ ',                                   [10])

    foorth_equal('  0 $tte .[]@ ',                            [10])
    foorth_equal('1 0 $tte .[]! ',                            [])
    foorth_equal('$tte @ ',                                   [1])
  end

  def test_the_left_group
    foorth_equal('2           [ 9 3 5 ]   .left   ', [[9,3]])
    foorth_equal('2           [ 9 3 5 ]   .-left  ', [[5]])
    foorth_equal('2 [ 0 8 9 ] [ 9 3 5 ]   .+left  ', [[0,8,9,5]])
  end

  def test_the_right_group
    foorth_equal('2           [ 9 3 5 ]   .right  ', [[3,5]])
    foorth_equal('2           [ 9 3 5 ]   .-right ', [[9]])
    foorth_equal('2 [ 0 8 9 ] [ 9 3 5 ]   .+right ', [[9,0,8,9]])
  end

  def test_the_mid_group
    foorth_equal('1 2           [ 9 3 5 7 ] .mid  ', [[3,5]])
    foorth_equal('1 2           [ 9 3 5 7 ] .-mid ', [[9,7]])
    foorth_equal('1 2 [ 0 8 9 ] [ 9 3 5 7 ] .+mid ', [[9,0,8,9,7]])
  end

  def test_the_midlr_group
    foorth_equal('1 1           [ 9 3 5 7 ] .midlr  ', [[3,5]])
    foorth_equal('1 1           [ 9 3 5 7 ] .-midlr ', [[9,7]])
    foorth_equal('1 1 [ 0 8 9 ] [ 9 3 5 7 ] .+midlr ', [[9,0,8,9,7]])
  end

  def test_other_array_ops
    foorth_equal('[ 0 1 2 ] .reverse   ', [[2,1,0]])
    foorth_equal('[ 9 3 5 ] .sort      ', [[3,5,9]])
    foorth_equal('[ 9 3 5 ] .length    ', [3])

    foorth_equal('[ 9 3 5 ] 0       << ', [[9,3,5,0]])
    foorth_equal('[ 9 3 5 ] [ 4 1 ] << ', [[9,3,5,[4,1]]])

    foorth_equal('[ 9 3 5 ] 0       + ', [[9,3,5,0]])
    foorth_equal('[ 9 3 5 ] [ 4 1 ] + ', [[9,3,5,4,1]])
  end

  def test_formatting_and_related
    foorth_equal('[ 0 1 "hello" ] .strmax', [5])
  end

  def test_array_min_max
    foorth_equal('[ 9 0 1 12 2 ] .min', [0])
    foorth_equal('[ 9 0 1 12 2 ] .max', [12])

    foorth_equal('[ "c" "d" "a" "g" "f" ] .min', ["a"])
    foorth_equal('[ "c" "d" "a" "g" "f" ] .max', ["g"])

  end


end
