# coding: utf-8

require_relative '../../lib/fOOrth/monkey_patch/numeric'
require_relative '../../lib/fOOrth/monkey_patch/complex'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class ComplexMonkeyPatchTester < MiniTest::Unit::TestCase

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  #Test that it embeds
  def test_foorth_embed
    comp = Complex(1,2)
    assert_equal(comp.foorth_embed, 'Complex(1,2)')
  end

end