# coding: utf-8

require_relative '../../lib/fOOrth/exceptions'
require_relative '../../lib/fOOrth/compiler/string_source'
require          'minitest/autorun'

#Test the monkey patches applied to the Object class.
class StringSourceTester < MiniTest::Unit::TestCase

  #Special initialize to track rake progress.
  def initialize(*all)
    $do_this_only_one_time = "" unless defined? $do_this_only_one_time

    if $do_this_only_one_time != __FILE__
      puts
      puts "Running test file: #{File.split(__FILE__)[1]}"
      $do_this_only_one_time = __FILE__
    end

    super(*all)
  end

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
