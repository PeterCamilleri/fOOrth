# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class OutStreamLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  $osfn = '"integration/out_stream_test_1.txt" '

  def test_that_class_exists
    foorth_equal('OutStream',       [XfOOrth::XfOOrth_OutStream])
    foorth_equal('OutStream .name', ['OutStream'])
  end

  def test_that_new_is_a_stub
    foorth_raises('OutStream .new')
  end

end
