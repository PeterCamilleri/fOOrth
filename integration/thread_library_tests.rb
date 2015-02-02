# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the fOOrth compile library.
class ThreadLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_the_current_thread
    foorth_equal('Thread .current     .name', ['Thread instance'])
    foorth_equal('Thread .current .vm .name', ['VirtualMachine instance <Main>'])
  end

  def test_the_main_thread
    foorth_equal('Thread .main        .name', ['Thread instance'])
    foorth_equal('Thread .main    .vm .name', ['VirtualMachine instance <Main>'])
  end

  def test_sleeping
    start = Time.now
    foorth_equal('0.05 .sleep', [])
    finish = Time.now
    assert(finish-start > 0.03)
    assert(finish-start < 0.1)
  end

  def test_creating_a_thread
    foorth_equal('0 var$: $tcat1', [])
    foorth_equal('"Test" Thread .new{ 1 $tcat1 ! } drop 0.01 .sleep $tcat1 @', [1])
  end


end
