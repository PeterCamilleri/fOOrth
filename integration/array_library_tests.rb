# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'

#Test the standard fOOrth library.
class ArrayLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Special initialize to track rake progress.
  def initialize(*all)
    $do_this_only_one_time = "" unless defined? $do_this_only_one_time

    if $do_this_only_one_time != __FILE__
      puts
      puts "Running test file: #{File.split(__FILE__)[1]}"
      $do_this_only_one_time = __FILE__
    end

    super(*all)
  end

  def test_some_array_basics
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

  def test_the_each
    foorth_equal('4 Array .new{ x 1 + dup * } global: $tte ', [])
    foorth_equal('$tte',                                      [[1,4,9,16]])

    foorth_equal('$tte .each{ x } ',                          [0,1,2,3])
    foorth_equal('$tte .each{ v } ',                          [1,4,9,16])

    foorth_equal(': tte $tte .each{ v } ;',                   [])
    foorth_equal('tte',                                       [1,4,9,16])
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
    foorth_equal('2           [ 9 3 5 ] .left   ', [[9,3]])
    foorth_equal('2           [ 9 3 5 ] .-left  ', [[5]])
    foorth_equal('2 [ 0 8 9 ] [ 9 3 5 ] .+left  ', [[0,8,9,5]])
  end

  def test_the_right_group
    foorth_equal('2   [ 9 3 5 ] .right  ', [[3,5]])
    foorth_equal('2   [ 9 3 5 ] .-right ', [[9]])
  end

  def test_the_mid_group
    foorth_equal('1 2 [ 9 3 5 7 ] .mid  ', [[3,5]])
    foorth_equal('1 2 [ 9 3 5 7 ] .-mid ', [[9,7]])
  end

  def test_the_midlr_group
    foorth_equal('1 1 [ 9 3 5 7 ] .midlr ', [[3,5]])
    foorth_equal('1 1 [ 9 3 5 7 ] .-midlr', [[9,7]])
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

end
