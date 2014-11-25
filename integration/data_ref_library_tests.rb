# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'

#Test the standard fOOrth library.
class DataRefLibraryTester < MiniTest::Unit::TestCase

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

  def test_basic_thread_variables
    foorth_equal('10 thread: #test1', [])
    foorth_equal('#test1 @',          [10])
    foorth_equal('20 #test1 !',       [])
    foorth_equal('#test1 @',          [20])
  end

  def test_basic_global_variables
    foorth_equal('10 global: $test1', [])
    foorth_equal('$test1 @',          [10])
    foorth_equal('20 $test1 !',       [])
    foorth_equal('$test1 @',          [20])
  end
end
