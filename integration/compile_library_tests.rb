# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the fOOrth compile library.
class CompileLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_creating_simple_words
    foorth_equal(': dbl dup + ; 4 dbl', [8])
    foorth_equal('9 dbl', [18])
  end

  def test_creating_immediate_words
    foorth_equal('!: five 5 ;', [])
    foorth_equal('five', [5])

    foorth_equal(': six five 6 ;', [5])
    foorth_equal('six', [6])
  end

  def test_simple_word_override
    foorth_equal(': foo 3 * ; 4 foo', [12])
    foorth_equal('5 foo', [15])
    foorth_equal(': foo 4 * ; 4 foo', [16])
    foorth_equal('5 foo', [20])
  end

  def test_creating_methods
    foorth_equal('Numeric .: .dbl self dup + ; 4 .dbl', [8])
    foorth_equal('9 .dbl', [18])
  end

  def test_methods_override
    foorth_equal('Numeric .: .foo self 3 * ; 4 .foo', [12])
    foorth_equal('5 .foo', [15])
    foorth_equal('Numeric .: .foo self 4 * ; 4 .foo', [16])
    foorth_equal('5 .foo', [20])
  end

  def test_words_with_local_vars
    foorth_equal(': lvt1 dup local: lv lv @ * ;' , [])
    foorth_equal('10 lvt1 ' , [100])
  end

  def test_methods_with_local_vars
    foorth_equal('Object .: .lvt2 dup local: lv lv @ * ;' , [])
    foorth_equal('10 Object .new .lvt2 ' , [100])
  end

  def test_exclusive_methods
    foorth_equal('class: X1 ' , [])
    foorth_equal('X1 .new global: $a' , [])
    foorth_equal('X1 .new global: $b' , [])

    foorth_equal('X1 .: .foobar "foo" ; ' , [])

    foorth_equal('$a @ .foobar' , ['foo'])
    foorth_equal('$b @ .foobar' , ['foo'])

    foorth_equal('$b @ .:: .foobar "bar" ;' , [])

    foorth_equal('$a @ .foobar' , ['foo'])
    foorth_equal('$b @ .foobar' , ['bar'])
  end

  def test_the_super_method
    foorth_equal('class: X2 ' , [])
    foorth_equal('X2 .new global: $c' , [])
    foorth_equal('X2 .: .foo 1 ; ' , [])
    foorth_equal('$c @ .foo' , [1])

    foorth_equal('X2 .subclass: X3 ' , [])
    foorth_equal('X3 .new global: $d' , [])
    foorth_equal('X3 .: .foo if super else 2 then ; ' , [])

    foorth_equal('true  $d @ .foo' , [1])
    foorth_equal('false $d @ .foo' , [2])

    foorth_equal('$c @ .foo' , [1])
  end

end
