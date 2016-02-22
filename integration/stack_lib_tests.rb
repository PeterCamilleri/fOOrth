# coding: utf-8

require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class StackLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  include MinitestVisible

  def test_the_stack_class_exists
    foorth_equal('Stack',             [XfOOrth::XfOOrth_Stack])
    foorth_equal('Stack .name',       ['Stack'])
    foorth_equal('Stack .new .class', [XfOOrth::XfOOrth_Stack])
    foorth_equal('Stack .new .name',  ['Stack instance'])
  end

  def test_some_stack_operations
    foorth_run('Stack .new val$: $s')
    foorth_equal('$s .empty?', [true])
    foorth_equal('$s .length', [0])

    foorth_equal('5 $s .push', [])
    foorth_equal('$s .peek',   [5])
    foorth_equal('$s .empty?', [false])
    foorth_equal('$s .length', [1])

    foorth_equal('6 $s .push', [])
    foorth_equal('$s .peek',   [6])
    foorth_equal('$s .empty?', [false])
    foorth_equal('$s .length', [2])

    foorth_equal('$s .pop',    [6])
    foorth_equal('$s .peek',   [5])
    foorth_equal('$s .empty?', [false])
    foorth_equal('$s .length', [1])

    foorth_equal('$s .pop',    [5])
    foorth_equal('$s .empty?', [true])
    foorth_equal('$s .length', [0])

  end

  def test_that_it_catches_underflows
    foorth_run('Stack .new val$: $s')

    foorth_raises('$s .pop')
    foorth_raises('$s .peek')

  end

  def test_stack_clear
    foorth_run('Stack .new val$: $s')

    foorth_run('42 $s .push')
    foorth_equal('$s .empty?', [false])
    foorth_equal('$s .peek', [42])

    foorth_run('$s .clear')

    foorth_equal('$s .empty?', [true])
    foorth_raises('$s .peek')
  end

end
