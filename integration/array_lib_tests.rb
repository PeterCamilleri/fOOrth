# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class ArrayLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  include MinitestVisible

  def test_some_array_basics
    foorth_equal('       Array                   ', [Array])

    foorth_equal('       Array .new              ', [[]])
    foorth_equal(': tt00 Array .new  ;           ', [])
    foorth_equal('tt00                           ', [[]])

    foorth_equal('       3 Array .new_size       ', [[0,0,0]])
    foorth_equal(': tt01 3 Array .new_size ;     ', [])
    foorth_equal('tt01                           ', [[0,0,0]])

    foorth_equal('try "apple" Array .new_size catch end', [])
    foorth_equal('try -3      Array .new_size catch end', [])


    foorth_equal('       3 Array .new_value      ', [[3]])
    foorth_equal(': tt02 3 Array .new_value ;    ', [])
    foorth_equal('tt02                           ', [[3]])

    foorth_equal('       3 2 Array .new_values   ', [[3,3]])
    foorth_equal(': tt03 3 2 Array .new_values ; ', [])
    foorth_equal('tt03                           ', [[3,3]])

    foorth_equal('try "apple" "pie" Array .new_values catch end', [])
    foorth_equal('try "apple" -3    Array .new_values catch end', [])

    foorth_equal('       3 Array .new{{ x }}     ', [[0,1,2]])
    foorth_equal(': tt04 3 Array .new{{ x }} ;   ', [])
    foorth_equal('tt04                           ', [[0,1,2]])

    foorth_equal('try      -3 Array .new{{ x }} catch end', [])
    foorth_equal('try "apple" Array .new{{ x }} catch end', [])
    foorth_equal('try       3 Array .new{{ throw"xx" }} catch end', [])

    foorth_equal('        [ 0 1 2 ]              ', [[0,1,2]])
    foorth_equal(': tt05  [ 0 1 2 ] ;            ', [])
    foorth_equal('tt05                           ', [[0,1,2]])

    foorth_equal('        [ 3 6 do i loop ]      ', [[3,4,5]])
    foorth_equal(': tt06  [ 3 6 do i loop ] ;    ', [])
    foorth_equal('tt06                           ', [[3,4,5]])
  end

  def test_arrays_in_variables
    foorth_equal('[ 3 6 9 ] val$: $taiv1 ',   [])
    foorth_equal('$taiv1                   ', [[3,6,9]])
  end

  def test_some_basic_operators
    foorth_equal('[ 3 6 9 ] [ 3 6 9 ]  = ', [true])
    foorth_equal('[ 3 6 9 ] [ 3 6 8 ]  = ', [false])
    foorth_equal('[ 3 6 9 ] [ 3 6 ]    = ', [false])

    foorth_equal('[ 3 6 9 ] [ 3 6 9 ]  <>', [false])
    foorth_equal('[ 3 6 9 ] [ 3 6 8 ]  <>', [true])
    foorth_equal('[ 3 6 9 ] [ 3 6 ]    <>', [true])

    foorth_equal('[ 3 6 9 ] [ 3 6 9 ] identical?', [false])
    foorth_equal('[ 3 6 9 ] [ 3 6 9 ] distinct?', [true])

    foorth_equal('[ 3 6 9 ] dup       identical?', [true])
    foorth_equal('[ 3 6 9 ] dup       distinct?', [false])

    foorth_equal('[ 3 6 9 ] clone     identical?', [false])
    foorth_equal('[ 3 6 9 ] clone     distinct?', [true])
  end

  def test_the_each
    foorth_equal('4 Array .new{{ x 1 + dup * }} val$: $tte ', [])
    foorth_equal('$tte',                                      [[1,4,9,16]])

    foorth_equal('$tte .each{{ x }} ',                        [0,1,2,3])
    foorth_equal('$tte .each{{ v }} ',                        [1,4,9,16])

    foorth_equal(': tte $tte .each{{ v }} ;',                 [])
    foorth_equal('tte',                                       [1,4,9,16])
  end

  def test_the_map
    foorth_equal('[ 2 3 4 ] .map{{ v 1+ }}', [[3,4,5]])
  end

  def test_the_select
    foorth_equal('[ 0 10 do i loop ] .select{{ v 1 and 0= }}', [[0,2,4,6,8]])
  end

  def test_simple_array_indexing
    foorth_equal('4 Array .new{{ x 1 + dup * }} val$: $tte ',   [])
    foorth_equal('$tte',                                      [[1,4,9,16]])

    foorth_equal('$tte @ ',                                   [1])
    foorth_equal('10 $tte ! ',                                [])
    foorth_equal('$tte @ ',                                   [10])

    foorth_equal('  0 $tte .[]@ ',                            [10])
    foorth_equal(' -1 $tte .[]@ ',                            [16])
    foorth_equal('1 0 $tte .[]! ',                            [])
    foorth_equal('$tte @ ',                                   [1])

    foorth_equal(' 10  $tte .[]@ ',                           [nil])
    foorth_equal('-10  $tte .[]@ ',                           [nil])

    foorth_equal(' "0" $tte .[]@ ',                           [1])
    foorth_equal('try "apple" $tte .[]@ catch end ',          [])

  end

  def test_the_left_group
    foorth_equal('2           [ 9 3 5 ]   .left   ', [[9,3]])
    foorth_equal('2           [ 9 3 5 ]   .-left  ', [[5]])
    foorth_equal('2 [ 0 8 9 ] [ 9 3 5 ]   .+left  ', [[0,8,9,5]])
    foorth_equal('2 "apple"   [ 9 3 5 ]   .+left  ', [["apple",5]])
    foorth_equal('2 [ 0 8 9 7 ]           .^left  ', [[9,7], [0,8]])

    foorth_equal('try "apple" [ 9 3 5 ] .left catch end', [])
    foorth_equal('try -1      [ 9 3 5 ] .left catch end', [])

    foorth_equal('try "apple" [ 9 3 5 ] .-left catch end', [])
    foorth_equal('try -1      [ 9 3 5 ] .-left catch end', [])

    foorth_equal('try -2      [ 0 8 9 ] [ 9 3 5 ] .+left catch end', [])
    foorth_equal('try "apple" [ 0 8 9 ] [ 9 3 5 ] .+left catch end', [])

    foorth_equal('try -2      [ 0 8 9 7 ] .^left catch end ', [])
    foorth_equal('try "apple" [ 0 8 9 7 ] .^left catch end ', [])
  end

  def test_the_right_group
    foorth_equal('2           [ 9 3 5 ]   .right  ', [[3,5]])
    foorth_equal('2           [ 9 3 5 ]   .-right ', [[9]])
    foorth_equal('2 [ 0 8 9 ] [ 9 3 5 ]   .+right ', [[9,0,8,9]])
    foorth_equal('2 "apple"   [ 9 3 5 ]   .+right ', [[9,"apple"]])
    foorth_equal('2 [ 0 8 9 7 ]           .^right ', [[0,8], [9,7]])

    foorth_equal('try "apple" [ 9 3 5 ] .right catch end', [])
    foorth_equal('try -1      [ 9 3 5 ] .right catch end', [])

    foorth_equal('try "apple" [ 9 3 5 ] .-right catch end', [])
    foorth_equal('try -1      [ 9 3 5 ] .-right catch end', [])

    foorth_equal('try -2      [ 0 8 9 ] [ 9 3 5 ] .+right catch end', [])
    foorth_equal('try "apple" [ 0 8 9 ] [ 9 3 5 ] .+right catch end', [])

    foorth_equal('try -2      [ 0 8 9 7 ] .^right catch end ', [])
    foorth_equal('try "apple" [ 0 8 9 7 ] .^right catch end ', [])
  end

  def test_the_mid_group
    foorth_equal('1 2           [ 9 3 5 7 ] .mid  ', [[3,5]])
    foorth_equal('1 2           [ 9 3 5 7 ] .-mid ', [[9,7]])
    foorth_equal('1 2 [ 0 8 9 ] [ 9 3 5 7 ] .+mid ', [[9,0,8,9,7]])
    foorth_equal('1 2 "apple"   [ 9 3 5 7 ] .+mid ', [[9,"apple",7]])
    foorth_equal('1 2           [ 9 3 5 7 ] .^mid ', [[9,7], [3,5]])

    foorth_equal('try "apple" 2 [ 9 3 5 7 ] .mid catch end', [])
    foorth_equal('try 1 "apple" [ 9 3 5 7 ] .mid catch end', [])
    foorth_equal('try -1      2 [ 9 3 5 7 ] .mid catch end', [])
    foorth_equal('try 1      -2 [ 9 3 5 7 ] .mid catch end', [])

    foorth_equal('try "apple" 2 [ 9 3 5 7 ] .-mid catch end', [])
    foorth_equal('try 1 "apple" [ 9 3 5 7 ] .-mid catch end', [])
    foorth_equal('try -1      2 [ 9 3 5 7 ] .-mid catch end', [])
    foorth_equal('try 1      -2 [ 9 3 5 7 ] .-mid catch end', [])

    foorth_equal('try "apple" 2 [ 0 8 9 ] [ 9 3 5 7 ] .+mid catch end ', [])
    foorth_equal('try 1 "apple" [ 0 8 9 ] [ 9 3 5 7 ] .+mid catch end ', [])
    foorth_equal('try -1      2 [ 0 8 9 ] [ 9 3 5 7 ] .+mid catch end ', [])
    foorth_equal('try 1      -2 [ 0 8 9 ] [ 9 3 5 7 ] .+mid catch end ', [])

    foorth_equal('try -1  2     [ 9 3 5 7 ] .^mid catch end', [])
    foorth_equal('try "apple" 2 [ 9 3 5 7 ] .^mid catch end', [])
    foorth_equal('try 1 -2      [ 9 3 5 7 ] .^mid catch end', [])
    foorth_equal('try 1 "apple" [ 9 3 5 7 ] .^mid catch end', [])
  end

  def test_the_midlr_group
    foorth_equal('1 1           [ 9 3 5 7 ] .midlr  ', [[3,5]])
    foorth_equal('1 1           [ 9 3 5 7 ] .-midlr ', [[9,7]])
    foorth_equal('0 2           [ 9 3 5 7 ] .-midlr ', [[5,7]])
    foorth_equal('2 0           [ 9 3 5 7 ] .-midlr ', [[9,3]])
    foorth_equal('1 1 [ 0 8 9 ] [ 9 3 5 7 ] .+midlr ', [[9,0,8,9,7]])
    foorth_equal('0 2 [ 0 8 9 ] [ 9 3 5 7 ] .+midlr ', [[0,8,9,5,7]])
    foorth_equal('2 0 [ 0 8 9 ] [ 9 3 5 7 ] .+midlr ', [[9,3,0,8,9]])
    foorth_equal('1 1 "apple"   [ 9 3 5 7 ] .+midlr ', [[9,"apple",7]])
    foorth_equal('1 1           [ 9 3 5 7 ] .^midlr ', [[9,7], [3,5]])

    foorth_equal('try "apple" 2 [ 9 3 5 7 ] .midlr catch end', [])
    foorth_equal('try 2 "apple" [ 9 3 5 7 ] .midlr catch end', [])
    foorth_equal('try -2      2 [ 9 3 5 7 ] .midlr catch end', [])
    foorth_equal('try 2      -2 [ 9 3 5 7 ] .midlr catch end', [])

    foorth_equal('try "apple" 2 [ 9 3 5 7 ] .-midlr catch end', [])
    foorth_equal('try 2 "apple" [ 9 3 5 7 ] .-midlr catch end', [])
    foorth_equal('try -2      2 [ 9 3 5 7 ] .-midlr catch end', [])
    foorth_equal('try 2      -2 [ 9 3 5 7 ] .-midlr catch end', [])

    foorth_equal('try "apple" 1 [ 0 8 9 ] [ 9 3 5 7 ] .+midlr catch end', [])
    foorth_equal('try 1 "apple" [ 0 8 9 ] [ 9 3 5 7 ] .+midlr catch end', [])
    foorth_equal('try -1      1 [ 0 8 9 ] [ 9 3 5 7 ] .+midlr catch end', [])
    foorth_equal('try 1      -1 [ 0 8 9 ] [ 9 3 5 7 ] .+midlr catch end', [])

    foorth_equal('try -1      1 [ 9 3 5 7 ] .^midlr catch end ', [])
    foorth_equal('try "apple" 1 [ 9 3 5 7 ] .^midlr catch end ', [])
    foorth_equal('try 1      -1 [ 9 3 5 7 ] .^midlr catch end ', [])
    foorth_equal('try 1 "apple" [ 9 3 5 7 ] .^midlr catch end ', [])
  end

  def test_the_dequeue_methods
    foorth_run('[ 1 2 3 ] val$: $tdqm')

    #Test the non-mutating methods.
    foorth_equal('$tdqm .pop_left', [[2,3], 1])
    foorth_equal('$tdqm ', [[1,2,3]])
    foorth_raises('[ ] .pop_left')

    foorth_equal('$tdqm .pop_right', [[1,2], 3])
    foorth_equal('$tdqm ', [[1,2,3]])
    foorth_raises('[ ] .pop_right')

    foorth_equal('0 $tdqm .push_left', [[0,1,2,3]])
    foorth_equal('$tdqm ', [[1,2,3]])

    foorth_equal('4 $tdqm .push_right', [[1,2,3,4]])
    foorth_equal('$tdqm ', [[1,2,3]])

    foorth_equal('$tdqm .peek_left', [[1,2,3], 1])
    foorth_equal('$tdqm ', [[1,2,3]])
    foorth_raises('[ ] .peek_left')

    foorth_equal('$tdqm .peek_right', [[1,2,3], 3])
    foorth_equal('$tdqm ', [[1,2,3]])
    foorth_raises('[ ] .peek_right')


    #Test the mutating methods.
    foorth_equal('$tdqm .pop_left!', [1])
    foorth_equal('$tdqm ', [[2,3]])
    foorth_raises('[ ] .pop_left!')

    foorth_equal('$tdqm .pop_right!', [3])
    foorth_equal('$tdqm ', [[2]])
    foorth_raises('[ ] .pop_right!')

    foorth_equal('1 $tdqm .push_left!', [])
    foorth_equal('$tdqm ', [[1,2]])

    foorth_equal('3 $tdqm .push_right!', [])
    foorth_equal('$tdqm ', [[1,2,3]])

    foorth_equal('$tdqm .peek_left!', [1])
    foorth_equal('$tdqm ', [[1,2,3]])
    foorth_raises('[ ] .peek_left!')

    foorth_equal('$tdqm .peek_right!', [3])
    foorth_equal('$tdqm ', [[1,2,3]])
    foorth_raises('[ ] .peek_right!')
  end

  def test_other_array_ops
    foorth_equal('[ 0 1 2 ] .reverse   ', [[2,1,0]])
    foorth_equal('[ 9 3 5 ] .sort      ', [[3,5,9]])

    foorth_equal('[ 9 3 5 ] .length    ', [3])

    foorth_equal('[ 9 3 5 ] 0       << ', [[9,3,5,0]])
    foorth_equal('[ 9 3 5 ] { }     << ', [[9,3,5,{}]])
    foorth_equal('[ 9 3 5 ] [ 4 1 ] << ', [[9,3,5,[4,1]]])
    foorth_equal('[ 9 3 5 ] [ 4 1 ] << ', [[9,3,5,[4,1]]])

    foorth_equal('[ 9 3 5 ] 0       + ', [[9,3,5,0]])
    foorth_equal('[ 9 3 5 ] [ 0 ]   + ', [[9,3,5,0]])
    foorth_equal('[ 9 3 5 ] { }     + ', [[9,3,5,{}]])

    foorth_equal('[ "9" 3 5 ] .sort   ', [[3,5,"9"]])
    foorth_equal('[ 9 "3" 5 ] .sort   ', [["3",5,9]])

    foorth_equal('try [ 9 "apple" 5 ] .sort catch end', [])
  end

  def test_formatting_and_related
    foorth_equal('[ 0 1 "hello" ] .strmax', [5])
  end

  def test_array_min_max
    foorth_equal('[ 9 0 1 12 2 ] .min', [0])
    foorth_equal('[ 9 0 1 12 2 ] .max', [12])

    foorth_equal('[ "c" "d" "a" "g" "f" ] .min', ["a"])
    foorth_equal('[ "c" "d" "a" "g" "f" ] .max', ["g"])

    foorth_equal('[ "9" 0 1 "pear" ] .min', ["0"])
    foorth_equal('[ "9" 0 1 "apple" ] .max', ["apple"])

    foorth_raises('[ 9 0 1 "pear" ] .min')
    foorth_raises('[ 9 0 1 "apple" ] .max')

    foorth_equal('try [ 9 0 1 "pear" ] .min catch end', [])
    foorth_equal('try [ 9 0 1 "pear" ] .max catch end', [])
  end

  def test_array_empty
    foorth_equal('[ ] .empty?', [true])
    foorth_equal('[ 1 2 3 ] .empty?', [false])
  end

  def test_array_split
    foorth_equal('1 2 [ 3 4 ] .split', [1,2,3,4])
  end

  def test_array_join
    foorth_equal('1 2 3 4 2 .join', [1,2,[3,4]])
    foorth_raises('1 2 3 4 -2 .join')
    foorth_raises('1 2 3 4 20 .join')
  end

  def test_scatter
    foorth_equal('[ 1 2 3 ]     .scatter', [1, 2, 3])
    foorth_equal('5 6 [ 1 2 3 ] .scatter', [5, 6, 1, 2, 3])
  end

  def test_gather
    foorth_equal('               gather', [[]])
    foorth_equal('    1 2 3      gather', [[1,2,3]])

    foorth_equal('    1 2 3 3   .gather', [[1,2,3]])
    foorth_equal('5 6 1 2 3 3   .gather', [5,6,[1,2,3]])

    foorth_raises('5 6 1 2 3 -1 .gather')
    foorth_raises('5 6 1 2 3  0 .gather')
    foorth_raises('5 6 1 2 3  9 .gather')
  end

  def test_array_to_s
    foorth_equal('[ 1 2 3 ] .to_s', ["[ 1 2 3 ]"])
  end

  def test_compatibility_methods
    foorth_equal('[ 2 4 6 8 ] .to_a   ', [[2,4,6,8]])
    foorth_equal('[ 2 4 6 8 ] .to_h   ', [{0=>2, 1=>4, 2=>6, 3=>8}])
    foorth_equal('[ 2 4 6 8 ] .values ', [[2,4,6,8]])
    foorth_equal('[ 2 4 6 8 ] .keys   ', [[0,1,2,3]])
  end

end
