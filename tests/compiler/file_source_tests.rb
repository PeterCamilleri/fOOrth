# coding: utf-8

$exclude_fOOrth_library = true
require_relative '../../lib/fOOrth'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class FileSourceTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  #Test that we can read from a single line string
  def test_single_line_file
    source = XfOOrth::FileSource.new("tests/compiler/file_source_test_one.txt")

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

    source.close
  end

  #Test that we can read from a multi-line string
  def test_multi_line_string
    source = XfOOrth::FileSource.new("tests/compiler/file_source_test_two.txt")

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

    source.close
  end

  #Test that we can read from a multi-line string again
  def test_multi_line_string_again
    source = XfOOrth::FileSource.new("tests/compiler/file_source_test_three.txt")

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

    source.close
  end

  #Test closing part way through the source.
  def test_closing
    source = XfOOrth::FileSource.new("tests/compiler/file_source_test_one.txt")

    assert_equal(source.get, 'a')
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
