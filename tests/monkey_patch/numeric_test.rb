# coding: utf-8

require_relative '../../lib/fOOrth/monkey_patch/numeric'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class NumericMonkeyPatchTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  #Test that it embeds
  def test_foorth_embed
    assert_equal(5.foorth_embed, '5')
    assert_equal((5.1).foorth_embed, '5.1')
  end

  #Test for conversion to a character.
  def test_to_character
    assert_equal(65.to_foorth_c, 'A')
    assert_equal((65.0).to_foorth_c, 'A')
    assert_equal(Rational(65,1).to_foorth_c, 'A')

    assert_equal(127.to_foorth_c, "\u007F")
    assert_equal(128.to_foorth_c, "\u0080")

    assert_equal(255.to_foorth_c, "\u00FF")
    assert_equal(256.to_foorth_c, "\u0100")

    assert_equal(169.to_foorth_c, "\u00A9")
    assert_equal(1120.to_foorth_c, "\u0460")

    assert_raises(XfOOrth::XfOOrthError) do
      Complex(65,0).to_foorth_c
    end

    assert_raises(XfOOrth::XfOOrthError) do
      1114112.to_foorth_c
    end

    assert_raises(XfOOrth::XfOOrthError) do
      (-2).to_foorth_c
    end
  end

  #Test for conversion to a numeric.
  def test_to_number
    assert_equal(65.to_foorth_n, 65)
    assert_equal((65.1).to_foorth_n, 65.1)
    assert_equal(Complex(65,0).to_foorth_n, Complex(65,0))
    assert_equal(Rational(65,1).to_foorth_n, Rational(65,1))
  end

  #Test for conversion to a rational.
  def test_to_rational
    assert_equal(Rational(13,10), (1.3).to_foorth_r)
  end

end

