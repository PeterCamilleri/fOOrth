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

    foorth_equal('5 $q .push', [])
    foorth_equal('$q .pop'   , [5])

  end


end