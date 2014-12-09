# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'

#Test the fOOrth compile library.
class ThreadLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Special initialize to track rake progress.
  def initialize(*all)
    $do_this_only_one_time = "" unless defined? $do_this_only_one_time

    if $do_this_only_one_time != __FILE__
      puts
      puts "Running test file: #{File.split(__FILE__)[1]}"
      $do_this_only_one_time = __FILE__
    end

    super(*all)
  end

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
    foorth_equal('0.1 .sleep', [])
    finish = Time.now
    assert(finish-start > 0.05)
    assert(finish-start < 0.15)
  end
end