# coding: utf-8

require_relative '../../lib/fOOrth/monkey_patch/numeric'
require_relative '../../lib/fOOrth/monkey_patch/rational'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class RationalMonkeyPatchTester < MiniTest::Unit::TestCase

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  #Test that it embeds
  def test_foorth_embed
    rat = '1/2'.to_r
    assert_equal(rat.foorth_embed, "'1/2'.to_r")
  end

end