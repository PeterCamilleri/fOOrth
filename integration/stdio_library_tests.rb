# coding: utf-8

require_relative './support/foorth_testing'
require          'minitest/autorun'

#Test the standard fOOrth library.
class StdioLibraryTester < MiniTest::Unit::TestCase

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

  def test_the_dot
    foorth_output('4 .', "4")
    foorth_output('-4 .', "-4")
    foorth_output('"test" .', "test")
    foorth_output('Object .name .', "Object")
  end

  def test_the_dot_quote
    foorth_output('."test"', "test")
  end

  def test_the_dot_cr
    foorth_output('.cr', "\n")
  end

end
