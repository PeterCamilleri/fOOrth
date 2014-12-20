# coding: utf-8

require_relative '../../lib/fOOrth/monkey_patch/object'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class ArrayMonkeyPatchTester < MiniTest::Unit::TestCase

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_to_pointer
    assert_equal([1,2,3].to_foorth_p, [1,2,3])
  end

end
