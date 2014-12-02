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

    foorth_equal('       3 Array .new{ x }       ', [[0,1,2]], true)
    foorth_equal(': tt04 3 Array .new{ x } ;     ', [])
    foorth_equal('tt04                           ', [[0,1,2]])
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

end
