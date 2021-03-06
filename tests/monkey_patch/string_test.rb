# coding: utf-8

require_relative '../../lib/fOOrth/monkey_patch/string'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class StringMonkeyPatchTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  #Test that it embeds
  def test_foorth_embed
    assert_equal("A big blue cat".foorth_embed, "\"A big blue cat\"")
    assert_equal("The cat's toy".foorth_embed,  "\"The cat's toy\"")
    assert_equal('A dog\cat race'.foorth_embed, "\"A dog\\\\cat race\"")
    assert_equal('A dog/cat race'.foorth_embed, "\"A dog/cat race\"")
  end

  #Test converting to a character.
  def test_to_character
    assert_equal('ABC'.to_foorth_c, 'A')
    assert_equal('A'.to_foorth_c,   'A')
    assert_equal(''.to_foorth_c,    nil)
  end

  #Test converting to a number.
  def test_to_number
    assert_equal('123'.to_foorth_n,   123)
    assert_equal('123.4'.to_foorth_n, 123.4)
    assert_equal('1/2'.to_foorth_n, '1/2'.to_r)
    assert_equal('1+2i'.to_foorth_n, Complex(1,2))
    assert_equal('2i'.to_foorth_n, Complex(0,2))
    assert_equal('1-2i'.to_foorth_n, Complex(1,-2))
    assert_equal('-2i'.to_foorth_n, Complex(0,-2))
    assert_equal('+1+2i'.to_foorth_n, Complex(1,2))
    assert_equal('+2i'.to_foorth_n, Complex(0,2))
    assert_equal('+1-2i'.to_foorth_n, Complex(1,-2))

    assert_equal('fubar'.to_foorth_n, nil)
    assert_equal('2cats'.to_foorth_n, nil)
  end

  def test_to_rational
    assert_equal(Rational(1,2), '1/2'.to_foorth_r)
    assert_equal(nil, 'apple'.to_foorth_r)
  end

  def test_clone_patches
    s = "abc"
    assert_equal(s.object_id, s.safe_clone.object_id)
    assert_equal(s.object_id, s.full_clone.object_id)

    b = StringBuffer.new('abc')
    refute_equal(b.object_id, b.safe_clone.object_id)
    refute_equal(b.object_id, b.full_clone.object_id)
  end

end
