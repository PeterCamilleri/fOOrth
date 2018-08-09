# coding: utf-8

require_relative '../../lib/fOOrth/monkey_patch/numeric'
require_relative '../../lib/fOOrth/monkey_patch/complex'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class ComplexMonkeyPatchTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  #Test that it embeds
  def test_foorth_embed
    comp = Complex(1,2)
    assert_equal(comp.foorth_embed, 'Complex(1,2)')
  end

  def test_that_it_is_not_rationalizable
    comp = Complex(1,2)
    assert_nil(comp.to_foorth_r)
  end
end