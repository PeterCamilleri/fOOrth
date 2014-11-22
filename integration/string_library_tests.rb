# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'

#Test the standard fOOrth library.
class StringLibraryTester < MiniTest::Unit::TestCase

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

  def test_left_justification
    foorth_equal('"a" 5 .lj ', ['a    '])
    foorth_equal('"too long" 5 .lj ', ['too long'])
  end

  def test_center_justification
    foorth_equal('"a" 5 .cj ', ['  a  '])
    foorth_equal('"too long" 5 .cj ', ['too long'])
  end

  def test_right_justification
    foorth_equal('"a" 5 .rj ', ['    a'])
    foorth_equal('"too long" 5 .rj ', ['too long'])
  end

  def test_formatted_strings
    foorth_equal('5 "%03d" .fmt ', ['005'])
    foorth_equal('5 .fmt"%03d"  ', ['005'])
  end

end
