# coding: utf-8

$exclude_fOOrth_library = true
require_relative '../../lib/fOOrth'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class StringSourceTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  #Test that we can read from a single line string
  def test_single_line_string
    test_string = "abc"
    source = XfOOrth::StringSource.new(test_string)

    assert_equal(source.get, 'a')
    refute(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, 'b')
    refute(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, 'c')
    refute(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, ' ')
    assert(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, nil)
    assert(source.eoln?)
    assert(source.eof?)
  end

  #Test that we can read from a multi-line string
  def test_multi_line_string
    test_string = "a\nb\nc"
    source = XfOOrth::StringSource.new(test_string)

    assert_equal(source.get, 'a')
    refute(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, ' ')
    assert(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, 'b')
    refute(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, ' ')
    assert(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, 'c')
    refute(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, ' ')
    assert(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, nil)
    assert(source.eoln?)
    assert(source.eof?)
  end

  #Test that we can read from a multi-line string again
  def test_multi_line_string_again
    test_string = "a\nb\nc\n"
    source = XfOOrth::StringSource.new(test_string)

    assert_equal(source.get, 'a')
    refute(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, ' ')
    assert(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, 'b')
    refute(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, ' ')
    assert(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, 'c')
    refute(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, ' ')
    assert(source.eoln?)
    refute(source.eof?)

    assert_equal(source.get, nil)
    assert(source.eoln?)
    assert(source.eof?)
  end

  #Test closing part way through the source.
  def test_closing
    test_string = "ABCDEFG - Eric the Half a Bee!"
    source = XfOOrth::StringSource.new(test_string)

    assert_equal(source.get, 'A')
    refute(source.eoln?)
    refute(source.eof?)

    source.close

    assert(source.eoln?)
    assert(source.eof?)

    assert_equal(source.get, nil)
    assert(source.eoln?)
    assert(source.eof?)
  end

end
