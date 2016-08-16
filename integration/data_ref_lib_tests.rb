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
  end

  def test_shared_instance_variables
    foorth_run('class: TIV01')
    foorth_run('TIV01 .: .init val@: @dder ;')
    foorth_run('TIV01 .: .add  @dder + ;')

    foorth_run('11 TIV01 .new  val$: $tiv01_01')
    foorth_equal('$tiv01_01 .class .name', ['TIV01'])
    foorth_equal('20 $tiv01_01 .add', [31])

    foorth_run('42 TIV01 .new  val$: $tiv01_02')
    foorth_equal('$tiv01_02 .class .name', ['TIV01'])
    foorth_equal('20 $tiv01_02 .add', [62])
  end

end
