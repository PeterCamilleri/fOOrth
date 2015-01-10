# coding: utf-8

require_relative '../../lib/fOOrth/monkey_patch'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the coerce protocol.
class CoerceProtocolTester < MiniTest::Unit::TestCase

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  #Test that it embeds
  def test_obect_stubs
    obj = Object.new

    assert_raises(XfOOrth::XfOOrthError) { obj.foorth_coerce(42) }
    assert_raises(XfOOrth::XfOOrthError) { obj.foorth_mnmx_coerce(42) }
  end


end
