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

  def test_that_we_can_write
    foorth_run($osfn + 'OutStream .create .close')
    assert(File.exists?($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_write_stuff
    foorth_run($osfn + 'OutStream .create dup 42 swap . .close')
    assert_equal(["42"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_write_stuff_too
    foorth_run($osfn + 'OutStream .create dup f"Hello World" .close')
    assert_equal(["Hello World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end

  def do_cleanup
    name = $osfn[1...-2]
    system("rm #{name}")
  end
end
