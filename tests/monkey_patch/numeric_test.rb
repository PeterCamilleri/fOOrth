# coding: utf-8

require_relative '../../lib/fOOrth/monkey_patch/numeric'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class NumericMonkeyPatchTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

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
      99120.to_foorth_c
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

  def test_mnmx_gt
    assert((4).mnmx_gt(0))
    refute((4).mnmx_gt(4))
    refute((4).mnmx_gt(8))
  end

  def test_mnmx_ge
    assert((4).mnmx_ge(0))
    assert((4).mnmx_ge(4))
    refute((4).mnmx_ge(8))
  end

  def test_mnmx_lt
    refute((4).mnmx_lt(0))
    refute((4).mnmx_lt(4))
    assert((4).mnmx_lt(8))
  end

  def test_mnmx_le
    refute((4).mnmx_le(0))
    assert((4).mnmx_le(4))
    assert((4).mnmx_le(8))
  end

  def test_mnmx_cp
    assert_equal( 1, (4).mnmx_cp(0))
    assert_equal( 0, (4).mnmx_cp(4))
    assert_equal(-1, (4).mnmx_cp(8))
  end

end

