# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class InStreamLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_that_class_exists
    foorth_equal('InStream',       [XfOOrth::XfOOrth_InStream])
    foorth_equal('InStream .name', ['InStream'])
  end

end
