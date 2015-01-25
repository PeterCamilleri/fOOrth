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
    foorth_equal($osfn + 'OutStream .create .close')
    assert(File.exists?($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_write_block
    foorth_equal($osfn + 'OutStream .create{ }')
    assert(File.exists?($osfn[1...-2]))
    do_cleanup
  end


  def test_that_we_can_write_stuff
    foorth_equal($osfn + 'OutStream .create dup 42 swap . .close')
    assert_equal(["42"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_write_block_stuff
    foorth_equal($osfn + 'OutStream .create{ 42 ~ }')
    assert_equal(["42"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end


  def test_that_we_can_write_stuff_too
    foorth_equal($osfn + 'OutStream .create dup f"Hello World" .close')
    assert_equal(["Hello World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_write_block_stuff_too
    foorth_equal($osfn + 'OutStream .create{ ~"Hello World" } ')
    assert_equal(["Hello World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end


  def test_that_we_can_write_a_character
    foorth_equal($osfn + 'OutStream .create  65 over .emit .close')
    assert_equal(["A"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_write_block_a_character
    foorth_equal($osfn + 'OutStream .create{ 65 ~emit }')
    assert_equal(["A"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end


  def test_that_we_can_write_out_lines
    foorth_equal($osfn + 'OutStream .create dup f"Hello" dup .cr dup f"World" .close', [])
    assert_equal(["Hello\n", "World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_block_write_out_lines
    foorth_equal($osfn + 'OutStream .create{ ~"Hello" ~cr ~"World" } ', [])
    assert_equal(["Hello\n", "World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end


  def test_that_we_can_write_out_a_space
    foorth_equal($osfn + 'OutStream .create dup f"Hello" dup .space dup f"World" .close', [])
    assert_equal(["Hello World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_block_write_out_a_space
    foorth_equal($osfn + 'OutStream .create{ ~"Hello" ~space ~"World" } ', [])
    assert_equal(["Hello World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end


  def test_that_we_can_write_out_spaces
    foorth_equal($osfn + 'OutStream .create dup f"Hello" dup 3 swap .spaces dup f"World" .close', [])
    assert_equal(["Hello   World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_block_write_out_spaces
    foorth_equal($osfn + 'OutStream .create{ ~"Hello" 3 ~spaces ~"World" } ', [])
    assert_equal(["Hello   World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end


  def test_that_we_can_append_a_character
    foorth_equal($osfn + 'OutStream .create  65 over .emit .close')
    assert_equal(["A"], IO.readlines($osfn[1...-2]))

    foorth_equal($osfn + 'OutStream .append  66 over .emit .close')
    assert_equal(["AB"], IO.readlines($osfn[1...-2]))

    do_cleanup
  end

  def test_that_we_can_block_append_a_character
    foorth_equal($osfn + 'OutStream .create  65 over .emit .close')
    assert_equal(["A"], IO.readlines($osfn[1...-2]))

    foorth_equal($osfn + 'OutStream .append{ 66 ~emit } ')
    assert_equal(["AB"], IO.readlines($osfn[1...-2]))

    do_cleanup
  end


  def do_cleanup
    name = $osfn[1...-2]
    system("rm #{name}")
  end
end
