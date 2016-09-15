# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class DataRefLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  include MinitestVisible

  def test_basic_thread_variables
    foorth_equal('10 var#: #test1',   [])
    foorth_equal('#test1 @',          [10])
    foorth_equal('20 #test1 !',       [])
    foorth_equal('#test1 @',          [20])

    foorth_equal('10 val#: #test2',   [])
    foorth_equal('#test2',            [10])

    foorth_run(': test_tv3 42 val#: #ttv3 ; ')
    foorth_equal('#ttv3',             [nil])
    foorth_run('test_tv3')
    foorth_equal('#ttv3',             [42])

    foorth_run(': test_tv5 42 var#: #ttv5 ; ')
    foorth_raises('#ttv5 #')
    foorth_run('test_tv5')
    foorth_equal('#ttv5 @',           [42])
  end

  def test_thread_vars_some_more
    foorth_run('42 val#:  #ttvsm ')
    foorth_output('#ttvsm  .', "42")
    foorth_output('{{ #ttvsm . }} .call ', "42")
    foorth_output('{{ #ttvsm . }} .start 0.001 .sleep ', "42")
  end

  def test_basic_global_variables
    foorth_equal('10 var$: $test1',   [])
    foorth_equal('$test1 @',          [10])
    foorth_equal('20 $test1 !',       [])
    foorth_equal('$test1 @',          [20])

    foorth_equal('10 val$: $test2',   [])
    foorth_equal('$test2',            [10])

    foorth_run(': test_gv4 69 val$: $tgv4 ; ')
    foorth_equal('$tgv4',             [nil])
    foorth_run('test_gv4')
    foorth_equal('$tgv4',             [69])

    foorth_run(': test_gv6 69 var$: $tgv6 ; ')
    foorth_raises('$tgv6 @')
    foorth_run('test_gv6')
    foorth_equal('$tgv6 @',           [69])
  end

  def test_shared_instance_variables
    foorth_run('class: TIV01')
    foorth_run('TIV01 .: .init val@: @dder  0 var@: @counter ;')
    foorth_run('TIV01 .: .add  @dder + ;')
    foorth_run('TIV01 .: .count  @counter @ 1+ dup @counter ! ;')

    foorth_run('11 TIV01 .new  val$: $tiv01_01')
    foorth_equal('$tiv01_01 .class .name', ['TIV01'])
    foorth_equal('20 $tiv01_01 .add', [31])
    foorth_equal('$tiv01_01 .count', [1])
    foorth_equal('$tiv01_01 .count', [2])
    foorth_equal('$tiv01_01 .count', [3])

    foorth_run('42 TIV01 .new  val$: $tiv01_02')
    foorth_equal('$tiv01_02 .class .name', ['TIV01'])
    foorth_equal('20 $tiv01_02 .add', [62])
    foorth_equal('$tiv01_02 .count', [1])
    foorth_equal('$tiv01_02 .count', [2])
    foorth_equal('$tiv01_02 .count', [3])

    foorth_equal('$tiv01_01 .count', [4])
  end

  def test_exclusive_instance_variables
    foorth_run('Object .new val$: $tiv02_01')
    foorth_run('$tiv02_01 .:: .init val@: @dder 0 var@: @counter ;')
    foorth_run('$tiv02_01 .:: .add @dder + ;')
    foorth_run('$tiv02_01 .:: .count  @counter @ 1+ dup @counter ! ;')

    foorth_run('11 $tiv02_01 .init ')
    foorth_equal('20 $tiv02_01 .add', [31])
    foorth_equal('$tiv02_01 .count', [1])
    foorth_equal('$tiv02_01 .count', [2])
    foorth_equal('$tiv02_01 .count', [3])

    foorth_run('$tiv02_01 .clone val$: $tiv02_02')
    foorth_run('42 $tiv02_02 .init ')
    foorth_equal('20 $tiv02_02 .add', [62])
    foorth_equal('$tiv02_02 .count', [1])
    foorth_equal('$tiv02_02 .count', [2])
    foorth_equal('$tiv02_02 .count', [3])

    foorth_equal('20 $tiv02_01 .add', [31])
    foorth_equal('$tiv02_01 .count', [4])
  end

end
