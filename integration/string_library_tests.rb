# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class StringLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_string_literals
    foorth_equal(' ""     ',  [""])
    foorth_equal(' "abc"  ',  ["abc"])
    foorth_equal(' "a\\\\c" ',  ["a\\c"])
    foorth_equal(' "a\\nb" ',  ["a\nb"])

    test_src1 = <<-'ONE'
    "abc\
     def"
    ONE

    assert_equal("    \"abc\\\n     def\"\n", test_src1)
    foorth_equal(test_src1,  ["abcdef"])

    test_src2 = <<-'TWO'
    "abc
    TWO

    assert_equal("    \"abc\n", test_src2)
    foorth_equal(test_src2,  ["abc"])

    foorth_equal(' "a\\x55b" ',  ["aUb"])
    foorth_equal(' "a\\u5555b" ',  ["a\u5555b"])
  end

  def test_file_loading
    foorth_equal('"integration/load_test_one.foorth" .load ', [42])
    foorth_equal('4 double ', [8])
    foorth_equal('"integration/load_test_one" .load ', [42])

    foorth_equal('load"integration/load_test_one.foorth"', [42])
    foorth_equal('load"integration/load_test_one"', [42])

    #foorth_equal(')load"integration/load_test_one.foorth"', [42])
    #foorth_equal(')load"integration/load_test_one"', [42])
  end

  def test_for_lines
    foorth_equal(' "abc\\ndef\\n123" .lines ',  [["abc", "def", "123"]])
  end

  def test_for_split
    foorth_equal(' "abc def 123" .split ',  [["abc", "def", "123"]])
  end

  def test_for_eval
    foorth_equal(' " 5 " .eval ', [5])
  end

  def test_some_string_basics
    foorth_equal('String    .new',     [""])
    foorth_equal('"abcdefg" .length ', [7])
  end

  def test_left_justification
    foorth_equal('5 "a"        .ljust ', ['a    '])
    foorth_equal('5 "too long" .ljust ', ['too long'])
  end

  def test_center_justification
    foorth_equal('5 "a"        .cjust ', ['  a  '])
    foorth_equal('5 "too long" .cjust ', ['too long'])
  end

  def test_right_justification
    foorth_equal('5 "a"        .rjust ', ['    a'])
    foorth_equal('5 "too long" .rjust ', ['too long'])
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
    foorth_equal('2 "abcdefgh"         .left  ',  ['ab'])
    foorth_equal('2 "123" "abcdefgh"   .+left ',  ['123cdefgh'])
    foorth_equal('2 "abcdefgh"         .-left ',  ['cdefgh'])
    foorth_equal('"abc" "abcdefgh"     .left? ',  [true])
    foorth_equal('"abx" "abcdefgh"     .left? ',  [false])
  end

  def test_right_copy_paste_and_cut
    foorth_equal('2 "abcdefgh"         .right  ', ['gh'])
    foorth_equal('2 "123" "abcdefgh"   .+right ', ['abcdef123'])
    foorth_equal('2 "abcdefgh"         .-right ', ['abcdef'])
    foorth_equal('"fgh" "abcdefgh"     .right? ', [true])
    foorth_equal('"fgx" "abcdefgh"     .right? ', [false])
  end

  def test_mid_copy_paste_and_cut
    foorth_equal('2 4 "abcdefgh"       .mid  ',   ['cdef'])
    foorth_equal('2 4 "abcdefgh"       .-mid ',   ['abgh'])
    foorth_equal('2 4 "123" "abcdefgh" .+mid ',   ['ab123gh'])
    foorth_equal('2 0 "123" "abcdefgh" .+mid ',   ['ab123cdefgh'])
    foorth_equal('"cde" "abcdefgh"     .mid? ',   [true])
    foorth_equal('"cdx" "abcdefgh"     .mid? ',   [false])
    foorth_equal('"cde" "abcdefgh"     .posn ',   [2])
    foorth_equal('"cdx" "abcdefgh"     .posn ',   [nil])
  end

  def test_midlr_copy_paste_and_cut
    foorth_equal('2 2 "abcdefgh"       .midlr  ', ['cdef'])
    foorth_equal('2 2 "abcdefgh"       .-midlr ', ['abgh'])
    foorth_equal('2 2 "123" "abcdefgh" .+midlr ', ['ab123gh'])
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

  def test_the_each
    foorth_equal('"abc" .each{ v x 1+ * } ', ['a', 'bb', 'ccc'])
  end

end
