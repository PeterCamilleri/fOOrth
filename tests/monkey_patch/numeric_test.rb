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

  def test_that_min_and_max_are_solo_acts
    assert_raises(XfOOrth::XfOOrthError) do
      MaxNumeric.new
    end

    assert_raises(XfOOrth::XfOOrthError) do
      MinNumeric.new
    end
  end

  def test_to_string
    assert_equal(MinNumeric.to_s, "min_num")
    assert_equal(MaxNumeric.to_s, "max_num")
  end

  #Test for conversion to a numeric.
  def test_to_number
    assert_equal(65.to_foorth_n, 65)
    assert_equal((65.1).to_foorth_n, 65.1)
    assert_equal(Complex(65,0).to_foorth_n, Complex(65,0))
    assert_equal(Rational(65,1).to_foorth_n, Rational(65,1))

    assert_raises(XfOOrth::XfOOrthError) do
      MaxNumeric.to_foorth_n
    end

    assert_raises(XfOOrth::XfOOrthError) do
      MinNumeric.to_foorth_n
    end

    assert_raises(XfOOrth::XfOOrthError) do
      MaxNumeric.to_i
    end

    assert_raises(XfOOrth::XfOOrthError) do
      MinNumeric.to_i
    end

  end

  def test_mnmx_gt
    assert((4).mnmx_gt(0))
    refute((4).mnmx_gt(4))
    refute((4).mnmx_gt(8))
    assert((4).mnmx_gt(MinNumeric))
    refute((4).mnmx_gt(MaxNumeric))

    refute((MinNumeric).mnmx_gt(0))
    refute((MinNumeric).mnmx_gt(4))
    refute((MinNumeric).mnmx_gt(8))
    refute((MinNumeric).mnmx_gt(MinNumeric))
    refute((MinNumeric).mnmx_gt(MaxNumeric))

    assert((MaxNumeric).mnmx_gt(0))
    assert((MaxNumeric).mnmx_gt(4))
    assert((MaxNumeric).mnmx_gt(8))
    assert((MaxNumeric).mnmx_gt(MinNumeric))
    refute((MaxNumeric).mnmx_gt(MaxNumeric))
  end

  def test_mnmx_ge
    assert((4).mnmx_ge(0))
    assert((4).mnmx_ge(4))
    refute((4).mnmx_ge(8))
    assert((4).mnmx_ge(MinNumeric))
    refute((4).mnmx_ge(MaxNumeric))

    refute((MinNumeric).mnmx_ge(0))
    refute((MinNumeric).mnmx_ge(4))
    refute((MinNumeric).mnmx_ge(8))
    assert((MinNumeric).mnmx_ge(MinNumeric))
    refute((MinNumeric).mnmx_ge(MaxNumeric))

    assert((MaxNumeric).mnmx_ge(0))
    assert((MaxNumeric).mnmx_ge(4))
    assert((MaxNumeric).mnmx_ge(8))
    assert((MaxNumeric).mnmx_ge(MinNumeric))
    assert((MaxNumeric).mnmx_ge(MaxNumeric))
  end

  def test_mnmx_lt
    refute((4).mnmx_lt(0))
    refute((4).mnmx_lt(4))
    assert((4).mnmx_lt(8))
    refute((4).mnmx_lt(MinNumeric))
    assert((4).mnmx_lt(MaxNumeric))

    assert((MinNumeric).mnmx_lt(0))
    assert((MinNumeric).mnmx_lt(4))
    assert((MinNumeric).mnmx_lt(8))
    refute((MinNumeric).mnmx_lt(MinNumeric))
    assert((MinNumeric).mnmx_lt(MaxNumeric))

    refute((MaxNumeric).mnmx_lt(0))
    refute((MaxNumeric).mnmx_lt(4))
    refute((MaxNumeric).mnmx_lt(8))
    refute((MaxNumeric).mnmx_lt(MinNumeric))
    refute((MaxNumeric).mnmx_lt(MaxNumeric))
  end

  def test_mnmx_le
    refute((4).mnmx_le(0))
    assert((4).mnmx_le(4))
    assert((4).mnmx_le(8))
    refute((4).mnmx_le(MinNumeric))
    assert((4).mnmx_le(MaxNumeric))

    assert((MinNumeric).mnmx_le(0))
    assert((MinNumeric).mnmx_le(4))
    assert((MinNumeric).mnmx_le(8))
    assert((MinNumeric).mnmx_le(MinNumeric))
    assert((MinNumeric).mnmx_le(MaxNumeric))

    refute((MaxNumeric).mnmx_le(0))
    refute((MaxNumeric).mnmx_le(4))
    refute((MaxNumeric).mnmx_le(8))
    refute((MaxNumeric).mnmx_le(MinNumeric))
    assert((MaxNumeric).mnmx_le(MaxNumeric))
  end

  def test_mnmx_cp
    assert_equal( 1, (4).mnmx_cp(0))
    assert_equal( 0, (4).mnmx_cp(4))
    assert_equal(-1, (4).mnmx_cp(8))
    assert_equal( 1, (4).mnmx_cp(MinNumeric))
    assert_equal(-1, (4).mnmx_cp(MaxNumeric))

    assert_equal(-1, (MinNumeric).mnmx_cp(0))
    assert_equal(-1, (MinNumeric).mnmx_cp(4))
    assert_equal(-1, (MinNumeric).mnmx_cp(8))
    assert_equal( 0, (MinNumeric).mnmx_cp(MinNumeric))
    assert_equal(-1, (MinNumeric).mnmx_cp(MaxNumeric))

    assert_equal( 1, (MaxNumeric).mnmx_cp(0))
    assert_equal( 1, (MaxNumeric).mnmx_cp(4))
    assert_equal( 1, (MaxNumeric).mnmx_cp(8))
    assert_equal( 1, (MaxNumeric).mnmx_cp(MinNumeric))
    assert_equal( 0, (MaxNumeric).mnmx_cp(MaxNumeric))
  end

end

