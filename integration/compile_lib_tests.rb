# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the fOOrth compile library.
class CompileLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  include MinitestVisible

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
    foorth_equal(': lvt1 dup var: lv lv @ * ;' , [])
    foorth_equal('10 lvt1 ' , [100])

    foorth_equal(': lvt2 val: lv lv  10 * ;' , [])
    foorth_equal('10 lvt2 ' , [100])
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

    foorth_equal('String .: .seesaw" self 2 * ; ', [])
    foorth_equal(' .seesaw"ab" ', ['abab'])

  end

  def test_methods_with_local_vars
    foorth_equal('Object .: .lvt5 dup var: lv lv @ * ;' , [])
    foorth_equal('10 Object .new .lvt5 ' , [100])

    foorth_equal('Object .: .lvt6 val: lv lv 10  * ;' , [])
    foorth_equal('10 Object .new .lvt6 ' , [100])
  end

  def test_exclusive_methods
    foorth_equal('class: X1 ' , [])
    foorth_equal('X1 .new var$: $a' , [])
    foorth_equal('X1 .new var$: $b' , [])

    foorth_equal('X1 .: .foobar "foo" ; ' , [])

    foorth_equal('$a @ .foobar' , ['foo'])
    foorth_equal('$b @ .foobar' , ['foo'])

    foorth_equal('$b @ .:: .foobar "bar" ;' , [])

    foorth_equal('$a @ .foobar' , ['foo'])
    foorth_equal('$b @ .foobar' , ['bar'])
  end

  def test_the_super_method
    foorth_equal('class: X2 ' , [])
    foorth_equal('X2 .new var$: $c' , [])
    foorth_equal('X2 .: .foo 1 ; ' , [])
    foorth_equal('$c @ .foo' , [1])

    foorth_equal('X2 .subclass: X3 ' , [])
    foorth_equal('X3 .new var$:  $d' , [])
    foorth_equal('X3 .: .foo if super else 2 then ; ' , [])

    foorth_equal('true  $d @ .foo' , [1])
    foorth_equal('false $d @ .foo' , [2])

    foorth_equal('$c @ .foo' , [1])
  end

  def test_for_unbalanced_code
    foorth_raises('true if   ')
    foorth_raises('true if : blah  ')

  end

  def test_for_delayed_compile
    foorth_run('true if : tfdc_foo "foo" ; then')
    foorth_equal('tfdc_foo', ["foo"])

    foorth_run('false if : tfdc_bar "bar" ; then')
    foorth_raises('tfdc_bar')

    foorth_run('true if !: tfdd_foo "foo" ; then')
    foorth_equal('tfdd_foo', ["foo"])

    foorth_run('false if !: tfdd_bar "bar" ; then')
    foorth_raises('tfdd_bar')

    foorth_run('true if Object .: .tfde_foo "foo" ; then')
    foorth_equal('Object .new .tfde_foo', ["foo"])

    foorth_run('false if Object .: .tfde_bar "bar" ; then')
    foorth_raises('Object .new .tfde_bar')

    foorth_run('Object .new val$: $tfdf_obj')
    foorth_run('true if $tfdf_obj .:: .tfdf_foo "foo" ; then')
    foorth_equal('$tfdf_obj .tfdf_foo', ["foo"])

    foorth_run('false if $tfdf_obj .:: .tfdf_bar "bar" ; then')
    foorth_raises('$tfdf_obj .tfdf_bar')
  end

  def test_for_FILE_method
    foorth_equal('_FILE_', [nil])

    nm = File.absolute_path('integration/_FILE_test.foorth')
    foorth_equal('"integration/_FILE_test.foorth" .load ', [nm, 7, nm])
  end

  def test_comments
    foorth_equal('42 (foo (bar) etc) 33', [42, 33])

    foorth_raises('(  (  )')

    foorth_equal('42 // foo bar etc 33', [42])
  end

  def test_method_casting
    foorth_equal('    asm"vm.push(vm.get_cast)" ', [nil] )
    foorth_equal('\'. asm"vm.push(vm.get_cast); vm.clear_cast" ', [XfOOrth::TosSpec] )
    foorth_equal('\'* asm"vm.push(vm.get_cast); vm.clear_cast" ', [XfOOrth::NosSpec] )
    foorth_equal('\'~ asm"vm.push(vm.get_cast); vm.clear_cast" ', [XfOOrth::SelfSpec] )

    foorth_raises('\'. ')
    foorth_raises('\'* ')
    foorth_raises('\'~ ')

    foorth_raises('\'. \'. ')
    foorth_raises('\'. \'* ')
    foorth_raises('\'. \'~ ')

    foorth_raises('\'* \'. ')
    foorth_raises('\'* \'* ')
    foorth_raises('\'* \'~ ')

    foorth_raises('\'~ \'. ')
    foorth_raises('\'~ \'* ')
    foorth_raises('\'~ \'~ ')

    foorth_equal('Object \'. .: .test ; asm"vm.push(vm.get_cast)" ', [nil] )

    foorth_raises("'. :  foo ; ")
    foorth_raises("'. !: foo ; ")

    foorth_raises("'* :  foo ; ")
    foorth_raises("'* !: foo ; ")

    foorth_raises("'~ :  foo ; ")
    foorth_raises("'~ !: foo ; ")

    foorth_equal("Integer    .: .riff self swap -  ; 10 5 .riff", [-5])
    foorth_equal("Integer '* .: .diff self swap -  ; 10 5 .diff", [5])

    foorth_equal("Integer    .: minus self swap -  ; 10 5 minus", [5])
    foorth_equal("Integer '. .: rinus self swap -  ; 10 5 rinus", [-5])
  end

  def test_method_aliasing
    foorth_run('class: TestAlias')
    foorth_run('TestAlias .: .method_name 42 ;')
    foorth_run('TestAlias .new val$: $test_aliasing_one')
    foorth_run('TestAlias .new val$: $test_aliasing_two')

    foorth_equal('$test_aliasing_one .method_name', [42])
    foorth_raises('$test_aliasing_one .alias_name')
    foorth_raises('$test_aliasing_one .with {{ ~other_name }}')

    foorth_run('".method_name" TestAlias .alias: .alias_name')

    foorth_equal('$test_aliasing_one .method_name', [42])
    foorth_equal('$test_aliasing_one .alias_name', [42])
    foorth_raises('$test_aliasing_one .with {{ ~other_name }}')

    foorth_run('".method_name" TestAlias .alias: ~other_name')

    foorth_equal('$test_aliasing_one .method_name', [42])
    foorth_equal('$test_aliasing_one .alias_name', [42])
    foorth_equal('$test_aliasing_one .with{{ ~other_name }}', [42])

    foorth_raises('".method_name" TestAlias .alias: ++++')

    foorth_run('$test_aliasing_two .:: .method_name 69 ;')
    foorth_equal('$test_aliasing_one .method_name', [42])
    foorth_equal('$test_aliasing_two .method_name', [69])

    foorth_run('".method_name" $test_aliasing_two .alias:: .crazy')
    foorth_equal('$test_aliasing_two .crazy', [69])
    foorth_raises('$test_aliasing_one .crazy')

    foorth_raises('"+" Numeric .alias: .add')
    foorth_run('"-" Numeric \'* .alias: .sub')
    foorth_equal('11 4 .sub', [7])

    foorth_run('"dup" alias: doop')
    foorth_equal('11 doop', [11, 11])
  end

  def test_method_stubs
    foorth_run('class: TestStubs')
    foorth_equal('TestStubs .new .to_i', [nil])

    foorth_run('TestStubs .stub: .to_i')
    foorth_raises('TestStubs .new .to_i')

    foorth_run('TestStubs .new val$: $test_stubs_one')
    foorth_run('TestStubs .new val$: $test_stubs_two')

    foorth_run('$test_stubs_two .stub:: .to_r')

    foorth_equal('$test_stubs_one .to_r', [nil])
    foorth_raises('$test_stubs_two .to_r')

    foorth_run('"dup" alias: dupe')
    foorth_equal('3 dup ', [3,3])
    foorth_equal('3 dupe', [3,3])

    foorth_run('stub: dup')

    foorth_raises('3 dup ')
    foorth_equal('3 dupe', [3,3])

    foorth_run('"dupe" alias: dup')
  end


end
