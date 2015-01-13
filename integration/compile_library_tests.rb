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

  def test_private_methods
    foorth_equal('class: PMTC', [])
    foorth_equal('PMTC .: ~t10 10 * ; ', [])
    foorth_equal('PMTC .: .t11  dup ~t10 + ; ', [])
    foorth_equal('5 PMTC .new   .t11  ', [55])
  end

  def test_some_invalid_names
    foorth_run('class: TSIN')

    foorth_raises('TSIN .: Bad ."wow" ; ')
    foorth_raises('TSIN .: @ad ."wow" ; ')
    foorth_raises('TSIN .: $ad ."wow" ; ')
    foorth_raises('TSIN .: #ad ."wow" ; ')

  end

  def test_spec_mapping
    foorth_run('class:  TempClass')
    foorth_run('TempClass .: .hi_aaa   42 ; ')

    foorth_run('class:  TempOther')
    foorth_run('TempOther .: .hi_aaa   69 ; ')

    foorth_equal('TempClass .new .hi_aaa', [42] )
    foorth_equal('TempOther .new .hi_aaa', [69] )

    foorth_run('TempClass .: + 42 + ; ')
    foorth_run('TempOther .: + 69 + ; ')

    foorth_equal('TempClass .new 10 + ', [52] )
    foorth_equal('TempOther .new 10 + ', [79] )

    foorth_run('TempClass .: add 42 + ; ')
    foorth_run('TempOther .: add 69 + ; ')

    foorth_equal('TempClass .new 10 add ', [52] )
    foorth_equal('TempOther .new 10 add ', [79] )

    foorth_run(': booboo 5 ;')
    foorth_raises('TempClass .: booboo 6 ;')

    foorth_run('TempClass .: bambam 6 ;')
    foorth_raises(': bambam 5 ;')

    foorth_raises('TempClass .: .seesaw" 6 ;')

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
