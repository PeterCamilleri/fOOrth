require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class StackLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_the_stack_class_exists
    foorth_equal('Stack',             [XfOOrth::XfOOrth_Stack])
    foorth_equal('Stack .name',       ['Stack'])
    foorth_equal('Stack .new .class', [XfOOrth::XfOOrth_Stack])
    foorth_equal('Stack .new .name',  ['Stack instance'])
  end

end