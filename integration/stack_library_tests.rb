require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class StackLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

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

    foorth_equal('6 $s .push', [])

    foorth_equal('$s .pop',    [6])

    foorth_equal('$s .pop',    [5])

  end

  def test_that_it_catches_underflows
    foorth_run('Stack .new val$: $s')

    foorth_raises('$s .pop')
    foorth_raises('$s .peek')

  end

end