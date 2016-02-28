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

  def test_creating_a_fiber
    test_code = <<-EOS
      Fiber .new{{  }} .class .name
    EOS

    foorth_equal(test_code, ["Fiber"])
  end

  def test_processing_data
    test_code = <<-EOS
      // Create a fibonacci fiber.
      Fiber .new{{ 1 1 begin dup .yield over + swap again }} val$: $fib

      0 8 do $fib .step loop
    EOS

    foorth_equal(test_code, [1, 1, 2, 3, 5, 8, 13, 21])
  end
end
