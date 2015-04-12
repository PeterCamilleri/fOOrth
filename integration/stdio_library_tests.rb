# coding: utf-8

require_relative './support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class StdioLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

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
    foorth_output('cr', "\n")
  end

  def test_the_space
    foorth_output('space', " ")
  end

  def test_the_spaces
    foorth_output('1 spaces', " ")
    foorth_output('2 spaces', "  ")
    foorth_output('0 spaces', "")
    foorth_raises('"apple"  spaces')
  end

  def test_the_emit
    foorth_output(' 65 .emit', "A")
    foorth_output('126 .emit', "~")

    foorth_utf8_output('255 .emit', [195, 191])

    foorth_output(' "A123" .emit', "A")
    foorth_raises('1+1i .emit')
  end

end
