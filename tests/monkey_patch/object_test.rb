# coding: utf-8

require_relative '../../lib/fOOrth/exceptions'
require_relative '../../lib/fOOrth/monkey_patch'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class ObjectMonkeyPatchTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  #Test that it does NOT foorth_embed.
  def test_foorth_embed_error
    obj = Object.new
    assert_raises(XfOOrth::XfOOrthError) { obj.foorth_embed }
  end

  #Test for conversion to a boolean.
  def test_to_boolean
    obj = Object.new
    assert_equal(obj.to_foorth_b, true)
  end

  #Test for conversion to a character.
  def test_to_character
    obj = Object.new
    assert_equal(obj.to_foorth_c, "\x00")
  end

  #Test for conversion to a number.
  def test_to_number
    obj = Object.new
    assert_equal(obj.to_foorth_n, nil)
  end

  #Test for conversion to a rational.
  def test_to_rational
    obj = Object.new
    assert_equal(obj.to_foorth_r, nil)
  end

  #Test the quick fail raise in fOOrth.
  def test_that_exceptions_are_easy_to_raise
    assert_raises(XfOOrth::XfOOrthError) { error('Failure IS an option!') }
  end

end
