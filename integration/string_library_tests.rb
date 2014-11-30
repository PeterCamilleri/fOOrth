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

  def test_some_string_basics
    foorth_equal('"abcdefg" .length ', [7])
  end

  def test_left_justification
    foorth_equal('"a" 5 .ljust ', ['a    '])
    foorth_equal('"too long" 5 .ljust ', ['too long'])
  end

  def test_center_justification
    foorth_equal('"a" 5 .cjust ', ['  a  '])
    foorth_equal('"too long" 5 .cjust ', ['too long'])
  end

  def test_right_justification
    foorth_equal('"a" 5 .rjust ', ['    a'])
    foorth_equal('"too long" 5 .rjust ', ['too long'])
  end

  def test_left_strip
    foorth_equal('" a " .lstrip ', ["a "])
  end

  def test_center_strip
    foorth_equal('" a " .strip ', ["a"])
  end

  def test_right_strip
    foorth_equal('" a " .rstrip ', [" a"])
  end

  def test_formatted_strings
    foorth_equal('5 "%03d" .fmt ', ['005'])
    foorth_equal('5 .fmt"%03d"  ', ['005'])
  end

  def test_left_copy_paste_and_cut
    foorth_equal('"abcdefgh" 2       .left ',  ['ab'])
    foorth_equal('"abcdefgh" 2 "123" .+left ', ['123cdefgh'])
    foorth_equal('"abcdefgh" 2       .-left ', ['cdefgh'])
  end

  def test_right_copy_paste_and_cut
    foorth_equal('"abcdefgh" 2       .right ',  ['gh'])
    foorth_equal('"abcdefgh" 2 "123" .+right ', ['abcdef123'])
    foorth_equal('"abcdefgh" 2       .-right ', ['abcdef'])
  end

  def test_mid_copy_paste_and_cut
    foorth_equal('"abcdefgh" 2 4        .mid ', ['cdef'])
    foorth_equal('"abcdefgh" 2 4       .-mid ', ['abgh'])
    foorth_equal('"abcdefgh" 2 4 "123" .+mid ', ['ab123gh'])
    foorth_equal('"abcdefgh" 2 0 "123" .+mid ', ['ab123cdefgh'])
  end

  def test_midlr_copy_paste_and_cut
    foorth_equal('"abcdefgh" 2 2       .midlr ',  ['cdef'])
    foorth_equal('"abcdefgh" 2 2       .-midlr ', ['abgh'])
    foorth_equal('"abcdefgh" 2 2 "123" .+midlr ', ['ab123gh'])
  end

  def test_replication
    foorth_equal('"abc" 0 *',  [''])
    foorth_equal('"abc" 1 *',  ['abc'])
    foorth_equal('"abc" 2 *',  ['abcabc'])
    foorth_equal('"abc" 3 *',  ['abcabcabc'])
  end

  def test_concatenation
    foorth_equal('"abc" 0     +',   ['abc0'])
    foorth_equal('"abc" "def" + ',  ['abcdef'])

    foorth_equal('"abc" 0     <<',  ['abc0'])
    foorth_equal('"abc" "def" << ', ['abcdef'])

    foorth_equal('"abc" dup "def" +  distinct?', [true])
    foorth_equal('"abc" dup "def" << distinct?', [false])
  end

  def test_case_changing
    foorth_equal('"abcDEF" .to_upper',  ['ABCDEF'])
    foorth_equal('"abcDEF" .to_lower',  ['abcdef'])
  end

  def test_reversing
    foorth_equal('"stressed" .reverse',  ['desserts'])
  end

end
