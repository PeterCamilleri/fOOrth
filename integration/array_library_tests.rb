# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'

#Test the standard fOOrth library.
class ArrayLibraryTester < MiniTest::Unit::TestCase

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

  def test_some_string_basics
    foorth_equal('Array .new ', [[]])
  end

end
