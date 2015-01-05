# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class HashLibraryTester < MiniTest::Unit::TestCase

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

  def test_hashes_in_variables
    foorth_equal('{ 1 3 -> 2 6 -> 3 9 -> } global: $thiv1 ', [])
    foorth_equal('$thiv1', [{1=>3, 2=>6, 3=>9}])
  end

  def test_simple_hash_indexing
    foorth_equal('{ 0 3 do i dup 3 * -> loop } global: $tshi1', [])
    foorth_equal('$tshi1', [{0=>0, 1=>3, 2=>6}])

    foorth_equal('$tshi1 @', [0])
    foorth_equal('1 $tshi1 !', [])
    foorth_equal('$tshi1 @', [1])

    foorth_equal('1 $tshi1 .[]@', [3])
    foorth_equal('4 1 $tshi1 .[]!', [])
    foorth_equal('1 $tshi1 .[]@', [4])
  end

  def test_the_hash_each
    foorth_equal('{ 0 3 do i dup 3 * -> loop } global: $tshi2', [])
    foorth_equal('$tshi2',                    [{0=>0, 1=>3, 2=>6}])

    foorth_equal('$tshi2 .each{ x } ',                     [0,1,2])
    foorth_equal('$tshi2 .each{ v } ',                     [0,3,6])

  end

end
