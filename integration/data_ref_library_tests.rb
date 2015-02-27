# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class DataRefLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

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
end
