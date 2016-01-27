# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class InOutStreamLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  # **** In Streams ****

  $isfn = '"integration/in_stream_test_1.txt" '

  def test_that_class_exists
    foorth_equal('InStream',       [XfOOrth::XfOOrth_InStream])
    foorth_equal('InStream .name', ['InStream'])
  end

  def test_that_new_is_a_stub
    foorth_raises('InStream .new')
  end

  def test_opening_and_reading_a_character
    foorth_equal($isfn + 'InStream .open dup .getc swap .close', ['T'])
  end

  def test_opening_and_reading_a_line
    foorth_equal($isfn + 'InStream .open dup .gets swap .close', ['Test 1 2 3'])
  end

  def test_open_block_and_reading_a_character
    foorth_equal($isfn + 'InStream .open{{ ~getc }}', ['T'])
  end

  def test_open_block_and_reading_a_line
    foorth_equal($isfn + 'InStream .open{{ ~gets }}', ['Test 1 2 3'])
  end

  def test_opening_and_reading_all_lines
    all_lines = ["Test 1 2 3",
                 "Test 4 5 6",
                 "ABCDEFG",
                 "Eric the Half a Bee"]

    foorth_equal($isfn + 'InStream .get_all', [all_lines])
  end

  # **** Out Streams ****

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
    foorth_equal($osfn + 'OutStream .create{{ }}')
    assert(File.exists?($osfn[1...-2]))
    do_cleanup
  end


  def test_that_we_can_write_stuff
    foorth_equal($osfn + 'OutStream .create dup 42 swap . .close')
    assert_equal(["42"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_write_block_stuff
    foorth_equal($osfn + 'OutStream .create{{ 42 ~ }}')
    assert_equal(["42"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end


  def test_that_we_can_write_stuff_too
    foorth_run($osfn + 'OutStream .create dup .with{{ ~"Hello World" }} .close')
    assert_equal(["Hello World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_write_block_stuff_too
    foorth_equal($osfn + 'OutStream .create{{ ~"Hello World" }}')
    assert_equal(["Hello World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end


  def test_that_we_can_write_a_character
    foorth_equal($osfn + 'OutStream .create  65 over .emit .close')
    assert_equal(["A"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_write_block_a_character
    foorth_equal($osfn + 'OutStream .create{{ 65 ~emit }}')
    assert_equal(["A"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end


  def test_that_we_can_write_out_lines
    foorth_run($osfn + 'OutStream .create .with{{ ~"Hello" ~cr ~"World" self .close }}')
    assert_equal(["Hello\n", "World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_block_write_out_lines
    foorth_equal($osfn + 'OutStream .create{{ ~"Hello" ~cr ~"World" }}', [])
    assert_equal(["Hello\n", "World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end


  def test_that_we_can_write_out_a_space
    foorth_run($osfn + 'OutStream .create .with{{ ~"Hello" self .space ~"World" self .close }}')
    assert_equal(["Hello World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_block_write_out_a_space
    foorth_equal($osfn + 'OutStream .create{{ ~"Hello" ~space ~"World" }}', [])
    assert_equal(["Hello World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end


  def test_that_we_can_write_out_spaces
    foorth_run($osfn + 'OutStream .create .with{{ ~"Hello" 3 self .spaces ~"World" self .close }}')
    assert_equal(["Hello   World"], IO.readlines($osfn[1...-2]))
    do_cleanup
  end

  def test_that_we_can_block_write_out_spaces
    foorth_equal($osfn + 'OutStream .create{{ ~"Hello" 3 ~spaces ~"World" }}', [])
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

    foorth_equal($osfn + 'OutStream .append{{ 66 ~emit }} ')
    assert_equal(["AB"], IO.readlines($osfn[1...-2]))

    do_cleanup
  end

  def test_put_and_append_all
    foorth_equal('[ "A" "B" "C" ] ' + $osfn + 'OutStream .put_all')
    assert_equal(["A\n", "B\n", "C\n"], IO.readlines($osfn[1...-2]))

    foorth_equal('[ "D" "E" "F" ] ' + $osfn + 'OutStream .append_all')
    assert_equal(["A\n", "B\n", "C\n", "D\n", "E\n", "F\n"], IO.readlines($osfn[1...-2]))

    do_cleanup
  end


  def do_cleanup
    name = $osfn[1...-2]
    system("rm #{name}")
  end

end
