# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class QueueLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_the_queue_class_exists
    foorth_equal('Queue', [Queue])
    foorth_equal('Queue .new .class', [Queue])
  end

  def test_some_queue_operations
    foorth_run('Queue .new val$: $q')
    foorth_equal('$q .empty?', [true])
    foorth_equal('$q .length', [0])

    foorth_equal('5 $q .push', [])
    foorth_equal('$q .empty?', [false])
    foorth_equal('$q .length', [1])

    foorth_equal('6 $q .push', [])
    foorth_equal('$q .empty?', [false])
    foorth_equal('$q .length', [2])

    foorth_equal('$q .pop'   , [5])
    foorth_equal('$q .empty?', [false])
    foorth_equal('$q .length', [1])

    foorth_equal('$q .pop'   , [6])
    foorth_equal('$q .empty?', [true])
    foorth_equal('$q .length', [0])

    foorth_equal('5 $q .push', [])
    foorth_equal('$q .empty?', [false])
    foorth_equal('$q .length', [1])
    foorth_equal('$q .clear',  [])
    foorth_equal('$q .empty?', [true])
    foorth_equal('$q .length', [0])

    foorth_equal('"A" $q .push $q .pend', ["A"])
  end

  def test_that_it_catches_underflows
    foorth_run('Queue .new val$: $q')
    foorth_raises('$q .pop')
  end

end
