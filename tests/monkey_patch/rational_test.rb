# coding: utf-8

require_relative '../../lib/fOOrth/monkey_patch/numeric'
require_relative '../../lib/fOOrth/monkey_patch/rational'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class RationalMonkeyPatchTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  #Test that it embeds
  def test_foorth_embed
    rat = '1/2'.to_r
    assert_equal(rat.foorth_embed, "'1/2'.to_r")
  end

  #Test for conversion to a rational.
  def test_to_rational
    rat = '1/2'.to_r
    assert_equal(rat.to_foorth_r, rat)
  end

  def test_coerce
    assert_equal(Rational(1,2), Rational.foorth_coerce(0.5))
    assert_equal(Rational(5,1), Rational.foorth_coerce(5))
    assert_equal(Rational(13,10), Rational.foorth_coerce(1.3))

    assert_raises(XfOOrth::XfOOrthError) do
      Rational.foorth_coerce("apple")
    end

    assert_raises(XfOOrth::XfOOrthError) do
      Rational.foorth_coerce(nil)
    end

    rat = '1/2'.to_r

    assert_equal(Rational(1,2), rat.foorth_coerce(0.5))
    assert_equal(Rational(5,1), rat.foorth_coerce(5))
    assert_equal(Rational(13,10), rat.foorth_coerce(1.3))

    assert_raises(XfOOrth::XfOOrthError) do
      rat.foorth_coerce("apple")
    end

    assert_raises(XfOOrth::XfOOrthError) do
      rat.foorth_coerce(nil)
    end
  end



end
