# coding: utf-8

require_relative '../../lib/fOOrth/monkey_patch/numeric'
require          'minitest/autorun'

#Test the monkey patches applied to the Object class.
class NumericMonkeyPatchTester < MiniTest::Unit::TestCase

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

  #Test that it embeds
  def test_foorth_embed
    assert_equal(5.foorth_embed, '5')
    assert_equal((5.1).foorth_embed, '5.1')
  end

  #Test for conversion to a character.
  def test_to_character
    assert_equal(65.to_foorth_c, 'A')
    assert_equal((65.0).to_foorth_c, 'A')
    assert_equal(Complex(65,0).to_foorth_c, 'A')
    assert_equal(Rational(65,1).to_foorth_c, 'A')

    assert_equal(127.to_foorth_c, "\u007F")
    assert_equal(128.to_foorth_c, "\u0080")

    assert_equal(255.to_foorth_c, "\u00FF")
    assert_equal(256.to_foorth_c, "\u0100")

    assert_equal(169.to_foorth_c, "\u00A9")
    assert_equal(1120.to_foorth_c, "\u0460")
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

  end

end