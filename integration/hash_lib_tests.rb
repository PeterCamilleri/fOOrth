# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class HashLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_some_hash_basics
    foorth_equal('Hash                    ', [Hash])
    foorth_equal('Hash .new               ', [{}])
    foorth_equal('{                    }  ', [{}])
    foorth_equal('{ 4 "A" ->  5 "B" -> }  ', [{4=>"A", 5=>"B"}])
    foorth_equal('{ 1 4 do i dup 3 * -> loop }', [{1=>3, 2=>6, 3=>9}])
  end

  def test_hashes_with_defaults
    foorth_run('42 Hash .new_default val$: $thwd')
    foorth_equal('$thwd', [{}])
    foorth_equal('"apple" $thwd .[]@', [42])

    foorth_run('99 "apple" $thwd .[]!')
    foorth_equal('"apple" $thwd .[]@', [99])

    foorth_run('Hash .new_default{{ 42 }} val$: $thwd')
    foorth_equal('$thwd', [{}])
    foorth_equal('"apple" $thwd .[]@', [42])

    foorth_run('99 "apple" $thwd .[]!')
    foorth_equal('"apple" $thwd .[]@', [99])
  end

  def test_hashes_in_variables
    foorth_equal('{ 1 3 -> 2 6 -> 3 9 -> } val$: $thiv1 ', [])
    foorth_equal('$thiv1', [{1=>3, 2=>6, 3=>9}])
  end

  def test_simple_hash_indexing
    foorth_equal('{ 0 3 do i dup 3 * -> loop } val$: $tshi1', [])
    foorth_equal('$tshi1', [{0=>0, 1=>3, 2=>6}])

    foorth_equal('1 $tshi1 .[]@', [3])
    foorth_equal('4 1 $tshi1 .[]!', [])
    foorth_equal('1 $tshi1 .[]@', [4])
  end

  def test_the_hash_each
    foorth_equal('{ 0 3 do i dup 3 * -> loop } val$: $tshi2', [])
    foorth_equal('$tshi2',                    [{0=>0, 1=>3, 2=>6}])

    foorth_equal('$tshi2 .each{{ x }} ',                   [0,1,2])
    foorth_equal('$tshi2 .each{{ v }} ',                   [0,3,6])

  end

  def test_keys_and_values
    foorth_equal('{ 0 3 do i dup 3 * -> loop } val$: $tshi3', [])

    foorth_equal('$tshi3 .keys',                         [[0,1,2]])
    foorth_equal('$tshi3 .values',                       [[0,3,6]])

  end

  def test_pretty_print_and_support
    foorth_equal('{ 0 11 do i dup dup * -> loop } val$: $tppas1', [])

    foorth_equal('$tppas1 .strmax2', [2,3])

  end

  def test_hash_length
    foorth_equal('{ "a" 1 -> "b" 2 -> } .length', [2])
  end

  def test_hash_empty
    foorth_equal('{ } .empty?', [true])
    foorth_equal('{ "a" 1 -> } .empty?', [false])
  end

  def test_hash_to_s
    foorth_equal('{ 1 2 -> 3 4 -> } .to_s', ["{ 1 2 -> 3 4 -> }"])
  end

  def test_compatibility_methods
    foorth_equal('{ 0 2 -> 1 4 -> 2 6 -> 3 8 -> } .to_h ', [{0=>2, 1=>4, 2=>6, 3=>8}])
    foorth_equal('{ 0 2 -> 1 4 -> 2 6 -> 3 8 -> } .to_a ', [[2,4,6,8]])
    foorth_equal('{ 0 2 -> 1 4 -> 2 6 -> 3 8 -> } .map{{ v 1+ }}', [{0=>3,1=>5,2=>7,3=>9}])
    foorth_equal('{ 0 2 -> 1 4 -> 2 6 -> 3 8 -> } .select{{ v 2/ 1 and 0= }}', [{1=>4, 3=>8}])
  end


end
