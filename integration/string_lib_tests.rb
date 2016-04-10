# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class StringLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  include MinitestVisible

  def test_string_classes
    foorth_equal('String ',            [String])
    foorth_equal('"A" .class ',        [String])
    foorth_equal('"A" .to_s* .class',  [StringBuffer])

    foorth_equal('StringBuffer ',      [StringBuffer])
    foorth_equal('"A"* .class ',       [StringBuffer])
    foorth_equal('"A"* .to_s .class ', [String])
  end

  def test_string_literals
    foorth_equal(' ""          ',  [""])
    foorth_equal(' "\""        ',  ["\""])
    foorth_equal(' "\"hello\"" ',  ["\"hello\""])
    foorth_equal(' "abc"       ',  ["abc"])
    foorth_equal(' "a\\\\c"    ',  ["a\\c"])
    foorth_equal(' "a\\nb"     ',  ["a\nb"])

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

    foorth_equal('"A"  .mutable?', [false])
    foorth_equal('"A"* .mutable?', [true])
  end

  def test_that_strings_are_immutable
    foorth_raises('"A" "B" <<')
  end

  def test_that_string_buffers_are_not
    foorth_equal('"A"* "B" <<', ["AB"])
    foorth_equal('"A"* "B" >>', ["BA"])
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

  def test_split_strings
    foorth_equal('load"integration/load_test_two"', ["foo  "])
  end

  def test_for_lines
    foorth_equal(' "abc\\ndef\\n123" .lines ',  [["abc", "def", "123"]])
  end

  def test_for_split
    foorth_equal(' "abc def 123" .split ',  [["abc", "def", "123"]])
  end

  def test_for_call
    foorth_equal(' " 5 " .call ', [5])
  end

  def test_some_string_basics
    foorth_equal('String    .new',     [""])
    foorth_equal('"abcdefg" .length ', [7])
  end

  def test_left_justification
    foorth_equal('5 "a"        .ljust ', ['a    '])
    foorth_equal('5 "too long" .ljust ', ['too long'])

    foorth_equal('5 "a" .ljust .mutable?', [false])
    foorth_equal('5 "a"* .ljust .class', [String])
  end

  def test_center_justification
    foorth_equal('5 "a"        .cjust ', ['  a  '])
    foorth_equal('5 "too long" .cjust ', ['too long'])

    foorth_equal('5 "a" .cjust .mutable?', [false])
    foorth_equal('5 "a"* .cjust .class', [String])
  end

  def test_right_justification
    foorth_equal('5 "a"        .rjust ', ['    a'])
    foorth_equal('5 "too long" .rjust ', ['too long'])

    foorth_equal('5 "a" .rjust .mutable?', [false])
    foorth_equal('5 "a"* .rjust .class', [String])
  end

  def test_left_strip
    foorth_equal('" a " .lstrip ', ["a "])

    foorth_equal('" a " .lstrip .mutable?', [false])
    foorth_equal('" a " .lstrip .class', [String])

    foorth_equal('" a "* .lstrip ', ["a "])
    foorth_equal('" a "* .lstrip .class', [String])

    foorth_run('" abc "* val$: $tls1')
    foorth_equal('$tls1', [" abc "])
    foorth_equal('$tls1 .lstrip*',  [])
    foorth_equal('$tls1 dup .class',  ["abc ", StringBuffer])
  end

  def test_center_strip
    foorth_equal('" a " .strip ', ["a"])

    foorth_equal('" a " .strip .mutable?', [false])
    foorth_equal('" a " .strip .class', [String])

    foorth_equal('" a "* .strip ', ["a"])
    foorth_equal('" a "* .strip .class', [String])

    foorth_run('" abc "* val$: $tcs1')
    foorth_equal('$tcs1', [" abc "])
    foorth_equal('$tcs1 .strip*',  [])
    foorth_equal('$tcs1 dup .class',  ["abc", StringBuffer])
  end

  def test_right_strip
    foorth_equal('" a " .rstrip ', [" a"])

    foorth_equal('" a " .rstrip .mutable?', [false])
    foorth_equal('" a " .rstrip .class', [String])

    foorth_equal('" a "* .rstrip ', [" a"])
    foorth_equal('" a "* .rstrip .class', [String])

    foorth_run('" abc "* val$: $trs1')
    foorth_equal('$trs1', [" abc "])
    foorth_equal('$trs1 .rstrip*',  [])
    foorth_equal('$trs1 dup .class',  [" abc", StringBuffer])
  end

  def test_formatted_strings
    foorth_equal('5 "%03d" format ', ['005'])
    foorth_equal('5 f"%03d"  ', ['005'])

    foorth_equal('5 f"%03d" .mutable?', [false])
  end

  def test_left_copy_paste_and_cut
    foorth_equal('2 "abcdefgh"         .left  ',  ['ab'])
    foorth_equal('2 "abcdefgh"*        .left  ',  ['ab'])
    foorth_equal('2 "abcdefgh"         .left  .mutable?', [false])
    foorth_equal('2 "abcdefgh"*        .left  .mutable?', [false])
    foorth_equal('2 "abcdefgh"         .left  .class',  [String])
    foorth_equal('2 "abcdefgh"*        .left  .class',  [String])

    foorth_equal('2 "123" "abcdefgh"   .+left ',  ['123cdefgh'])
    foorth_equal('2 "123" "abcdefgh"*  .+left ',  ['123cdefgh'])
    foorth_equal('2 "123" "abcdefgh"   .+left .mutable?', [false])
    foorth_equal('2 "123" "abcdefgh"*  .+left .mutable?', [false])
    foorth_equal('2 "123" "abcdefgh"   .+left .class',  [String])
    foorth_equal('2 "123" "abcdefgh"*  .+left .class',  [String])

    foorth_equal('2 "abcdefgh"         .-left ',  ['cdefgh'])
    foorth_equal('2 "abcdefgh"*        .-left ',  ['cdefgh'])
    foorth_equal('2 "abcdefgh"         .-left .mutable?', [false])
    foorth_equal('2 "abcdefgh"*        .-left .mutable?', [false])
    foorth_equal('2 "abcdefgh"         .-left .class',  [String])
    foorth_equal('2 "abcdefgh"*        .-left .class',  [String])

    foorth_equal('"abc" "abcdefgh"     .left? ',  [true])
    foorth_equal('"abx" "abcdefgh"     .left? ',  [false])
    foorth_equal('"abc" "abcdefgh"*    .left? ',  [true])
    foorth_equal('"abx" "abcdefgh"*    .left? ',  [false])
    foorth_equal('"abc"* "abcdefgh"    .left? ',  [true])
    foorth_equal('"abx"* "abcdefgh"    .left? ',  [false])
    foorth_equal('"abc"* "abcdefgh"*   .left? ',  [true])
    foorth_equal('"abx"* "abcdefgh"*   .left? ',  [false])
  end

  def test_right_copy_paste_and_cut
    foorth_equal('2 "abcdefgh"         .right  ', ['gh'])
    foorth_equal('2 "abcdefgh"*        .right  ', ['gh'])
    foorth_equal('2 "abcdefgh"         .right .mutable?', [false])
    foorth_equal('2 "abcdefgh"*        .right .mutable?', [false])
    foorth_equal('2 "abcdefgh"         .right .class',  [String])
    foorth_equal('2 "abcdefgh"*        .right .class',  [String])

    foorth_equal('2 "123" "abcdefgh"   .+right ', ['abcdef123'])
    foorth_equal('2 "123" "abcdefgh"*  .+right ', ['abcdef123'])
    foorth_equal('2 "123" "abcdefgh"   .+right .mutable?', [false])
    foorth_equal('2 "123" "abcdefgh"*  .+right .mutable?', [false])
    foorth_equal('2 "123" "abcdefgh"   .+right .class',  [String])
    foorth_equal('2 "123" "abcdefgh"*  .+right .class',  [String])

    foorth_equal('2 "abcdefgh"         .-right ', ['abcdef'])
    foorth_equal('2 "abcdefgh"*        .-right ', ['abcdef'])
    foorth_equal('2 "abcdefgh"         .-right .mutable?', [false])
    foorth_equal('2 "abcdefgh"*        .-right .mutable?', [false])
    foorth_equal('2 "abcdefgh"         .-right .class',  [String])
    foorth_equal('2 "abcdefgh"*        .-right .class',  [String])

    foorth_equal('"fgh" "abcdefgh"     .right? ', [true])
    foorth_equal('"fgx" "abcdefgh"     .right? ', [false])
    foorth_equal('"fgh" "abcdefgh"*    .right? ', [true])
    foorth_equal('"fgx" "abcdefgh"*    .right? ', [false])
    foorth_equal('"fgh"* "abcdefgh"    .right? ', [true])
    foorth_equal('"fgx"* "abcdefgh"    .right? ', [false])
    foorth_equal('"fgh"* "abcdefgh"*   .right? ', [true])
    foorth_equal('"fgx"* "abcdefgh"*   .right? ', [false])
  end

  def test_mid_copy_paste_and_cut
    foorth_equal('2 4 "abcdefgh"       .mid  ',   ['cdef'])
    foorth_equal('2 4 "abcdefgh"*      .mid  ',   ['cdef'])
    foorth_equal('2 4 "abcdefgh"       .mid .mutable?', [false])
    foorth_equal('2 4 "abcdefgh"*      .mid .mutable?', [false])
    foorth_equal('2 4 "abcdefgh"       .mid .class',  [String])
    foorth_equal('2 4 "abcdefgh"*      .mid .class',  [String])

    foorth_equal('2 4 "abcdefgh"       .-mid ',   ['abgh'])
    foorth_equal('2 4 "abcdefgh"*      .-mid ',   ['abgh'])
    foorth_equal('2 4 "abcdefgh"       .-mid .mutable?', [false])
    foorth_equal('2 4 "abcdefgh"*      .-mid .mutable?', [false])
    foorth_equal('2 4 "abcdefgh"       .-mid .class',  [String])
    foorth_equal('2 4 "abcdefgh"*      .-mid .class',  [String])

    foorth_equal('2 4 "123" "abcdefgh" .+mid ',   ['ab123gh'])
    foorth_equal('2 0 "123" "abcdefgh" .+mid ',   ['ab123cdefgh'])
    foorth_equal('2 4 "123" "abcdefgh"* .+mid ',  ['ab123gh'])
    foorth_equal('2 0 "123" "abcdefgh"* .+mid ',  ['ab123cdefgh'])
    foorth_equal('2 4 "123"* "abcdefgh" .+mid ',  ['ab123gh'])
    foorth_equal('2 0 "123"* "abcdefgh" .+mid ',  ['ab123cdefgh'])
    foorth_equal('2 4 "123"* "abcdefgh"* .+mid ', ['ab123gh'])
    foorth_equal('2 0 "123"* "abcdefgh"* .+mid ', ['ab123cdefgh'])

    foorth_equal('2 4 "123" "abcdefgh" .+mid   .mutable?', [false])
    foorth_equal('2 0 "123" "abcdefgh" .+mid   .mutable?', [false])
    foorth_equal('2 4 "123" "abcdefgh"* .+mid  .mutable?', [false])
    foorth_equal('2 0 "123" "abcdefgh"* .+mid  .mutable?', [false])
    foorth_equal('2 4 "123"* "abcdefgh" .+mid  .mutable?', [false])
    foorth_equal('2 0 "123"* "abcdefgh" .+mid  .mutable?', [false])
    foorth_equal('2 4 "123"* "abcdefgh"* .+mid .mutable?', [false])
    foorth_equal('2 0 "123"* "abcdefgh"* .+mid .mutable?', [false])

    foorth_equal('2 4 "123" "abcdefgh" .+mid   .class',  [String])
    foorth_equal('2 0 "123" "abcdefgh" .+mid   .class',  [String])
    foorth_equal('2 4 "123" "abcdefgh"* .+mid  .class',  [String])
    foorth_equal('2 0 "123" "abcdefgh"* .+mid  .class',  [String])
    foorth_equal('2 4 "123"* "abcdefgh" .+mid  .class',  [String])
    foorth_equal('2 0 "123"* "abcdefgh" .+mid  .class',  [String])
    foorth_equal('2 4 "123"* "abcdefgh"* .+mid .class',  [String])
    foorth_equal('2 0 "123"* "abcdefgh"* .+mid .class',  [String])
  end

  def test_mid_find
    foorth_equal('2 "cde" "abcdefgh"    .mid? ',   [true])
    foorth_equal('3 "cde" "abcdefgh"    .mid? ',   [false])

    foorth_equal('2 "cde"* "abcdefgh"    .mid? ',   [true])
    foorth_equal('3 "cde"* "abcdefgh"    .mid? ',   [false])

    foorth_equal('2 "cde" "abcdefgh"*    .mid? ',   [true])
    foorth_equal('3 "cde" "abcdefgh"*    .mid? ',   [false])

    foorth_equal('2 "cde"* "abcdefgh"*    .mid? ',   [true])
    foorth_equal('3 "cde"* "abcdefgh"*    .mid? ',   [false])
  end

  def test_midlr_copy_paste_and_cut
    foorth_equal('2 2 "abcdefgh"       .midlr  ', ['cdef'])
    foorth_equal('2 2 "abcdefgh"*      .midlr  ', ['cdef'])
    foorth_equal('2 2 "abcdefgh"       .midlr  .mutable?', [false])
    foorth_equal('2 2 "abcdefgh"*      .midlr  .mutable?', [false])
    foorth_equal('2 2 "abcdefgh"       .midlr  .class',  [String])
    foorth_equal('2 2 "abcdefgh"*      .midlr  .class',  [String])

    foorth_equal('2 2 "abcdefgh"       .-midlr ', ['abgh'])
    foorth_equal('2 2 "abcdefgh"*      .-midlr ', ['abgh'])
    foorth_equal('2 2 "abcdefgh"       .-midlr .mutable?', [false])
    foorth_equal('2 2 "abcdefgh"*      .-midlr .mutable?', [false])
    foorth_equal('2 2 "abcdefgh"       .-midlr .class',  [String])
    foorth_equal('2 2 "abcdefgh"*      .-midlr .class',  [String])

    foorth_equal('2 2 "123" "abcdefgh" .+midlr ', ['ab123gh'])
    foorth_equal('2 2 "123" "abcdefgh"*.+midlr ', ['ab123gh'])
    foorth_equal('2 2 "123"* "abcdefgh" .+midlr ', ['ab123gh'])
    foorth_equal('2 2 "123"* "abcdefgh"*.+midlr ', ['ab123gh'])

    foorth_equal('2 2 "123" "abcdefgh" .+midlr .mutable?', [false])
    foorth_equal('2 2 "123" "abcdefgh"*.+midlr .mutable?', [false])
    foorth_equal('2 2 "123"* "abcdefgh" .+midlr .mutable?', [false])
    foorth_equal('2 2 "123"* "abcdefgh"*.+midlr .mutable?', [false])

    foorth_equal('2 2 "123" "abcdefgh" .+midlr .class',  [String])
    foorth_equal('2 2 "123" "abcdefgh"*.+midlr .class',  [String])
    foorth_equal('2 2 "123"* "abcdefgh" .+midlr .class',  [String])
    foorth_equal('2 2 "123"* "abcdefgh"*.+midlr .class',  [String])
  end

  def test_string_contains
    foorth_equal('"cde" "abcdefgh"  .contains? ',   [true])
    foorth_equal('"cdx" "abcdefgh"  .contains? ',   [false])
  end

  def test_string_posn
    foorth_equal('"cde" "abcdefgh"      .posn ',   [2])
    foorth_equal('"cdx" "abcdefgh"      .posn ',   [nil])
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

    foorth_equal('"abc"* 0     <<',  ['abc0'])
    foorth_equal('"abc"* "def" << ', ['abcdef'])

    foorth_equal(' "abc" dup "def" +  distinct?', [true])
    foorth_equal('"abc"* dup "def" << distinct?', [false])
  end

  def test_case_changing
    foorth_equal('"abcDEF" .to_upper',  ['ABCDEF'])
    foorth_equal('"abcDEF" .to_lower',  ['abcdef'])
  end

  def test_reversing
    foorth_equal('"stressed" .reverse',  ['desserts'])
  end

  def test_the_each
    foorth_equal('"abc" .each{{ v x 1+ * }} ', ['a', 'bb', 'ccc'])
    foorth_equal('"abc" .each{{ v .mutable? }} ', [false, false, false])
  end

  def test_calling_a_string
    foorth_equal('"1 2 +" .call ', [3])
  end

  def test_capturing_shell_output
    foorth_equal('"ls" .shell_out .class ', [String])
  end

  def test_parsing_some_strings
    foorth_equal('"1 2 3" p"%d %d %d"', [[1,2,3]])
    foorth_equal('"1 2 3" "%d %d %d" parse', [[1,2,3]])

    foorth_equal('"12 34 -56" p"%d %2d %4d"', [[12, 34, -56]])
    foorth_equal('"255 0b11111111 0377 0xFF 0 " p"%i %i %i %i %i"', [[255, 255, 255, 255, 0]])
    foorth_equal('"7 10 377" p"%o %o %o"', [[7, 8, 255]])
    foorth_equal('"10 10011 11110000" p"%b %b %b"',[[2, 19, 240]])
    foorth_equal('"0 F FF FFF FFFF" p"%x %x %x %x %x"', [[0, 15, 255, 4095, 65535]])
    foorth_equal('"Hello Silly World" p"%s %*s %s"', [["Hello", "World"]])
    foorth_equal('"Hello Silly World" p"%5c %*5c %5c"', [["Hello", "World"]])
    foorth_equal('"42 The secret is X" p"%i %-1c"', [[42, "The secret is X"]])
    foorth_equal('"42 The secret is X" p"%i %-2c%c"', [[42, "The secret is ", "X"]])
    foorth_equal('"42 The secret is X" p"%i %*-2c%c"', [[42, "X"]])
    foorth_equal('"9.99 1.234e56 -1e100" p"%f %f %f"', [[9.99, 1.234e56, -1e100]])
    foorth_equal('"85% 75%" p"%f%% %f%%"', [[85, 75]])
    foorth_equal('"12 34 -56" p"%u %u %u"', [[12, 34]])
    foorth_equal('"1/2 3/4r -5/6" p"%r %r %r"', [['1/2'.to_r, '3/4'.to_r, '-5/6'.to_r]])
    foorth_equal('"1+2i 3+4j -5e10-6.2i" p"%j %j %j"',
                 [[Complex('1+2i'), Complex('3+4j'), Complex('-5e10-6.2i')]])
    s = "\"'quote' 'silly' \\\"un quote\\\" 'a \\\\'' \" p\"%q %*q %q %q\"  "
    foorth_equal(s, [["quote", "un quote", "a '"]])
    foorth_equal('"a b c" p"%[a] %[b] %[c]"', [["a", "b", "c"]])

    foorth_equal('"Hello World" p"%s %s" .map{{ v .mutable? }}', [[false, false]])
  end

end
