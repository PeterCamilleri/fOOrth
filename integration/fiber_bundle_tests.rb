# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class FiberBundleLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  include MinitestVisible

  def test_that_the_fiber_classes_exist
    foorth_equal('Fiber',  [XfOOrth::XfOOrth_Fiber])
    foorth_equal('Bundle', [XfOOrth::XfOOrth_Bundle])
  end


end
