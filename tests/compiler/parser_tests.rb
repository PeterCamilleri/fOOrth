# coding: utf-8

require_relative '../../lib/fOOrth/exceptions'
require_relative '../../lib/fOOrth/compiler/string_source'
require_relative '../../lib/fOOrth/compiler/parser'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class ParserTester < MiniTest::Unit::TestCase

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  #Test simple parsing into words.
  def test_parsing_words_raw
    test_string = '2 3 + .'
    source = XfOOrth::StringSource.new(test_string)
    parser = XfOOrth::Parser.new(source)

    assert_equal(parser.get_word_raw, '2')
    assert_equal(parser.get_word_raw, '3')
    assert_equal(parser.get_word_raw, '+')
    assert_equal(parser.get_word_raw, '.')
    assert_equal(parser.get_word_raw, nil)
  end

  #Test parsing strings.
  def test_parsing_strings
    test_string = '."Testing 1 2 3"'
    source = XfOOrth::StringSource.new(test_string)
    parser = XfOOrth::Parser.new(source)

    assert_equal(parser.get_word_raw, '."')
    assert_equal(parser.get_string, 'Testing 1 2 3')
  end

  #Test parsing open ended strings.
  def test_parsing_open_ended_strings
    test_string = '."Testing 1 2 3' + "\n"
    source = XfOOrth::StringSource.new(test_string)
    parser = XfOOrth::Parser.new(source)

    assert_equal(parser.get_word_raw, '."')
    assert_equal(parser.get_string, 'Testing 1 2 3')
  end

  #Test parsing strings some more.
  def test_parsing_strings_breaks
    test_string = '."Testing 1 ' + "\\" + "\n" + '2 3"'
    source = XfOOrth::StringSource.new(test_string)
    parser = XfOOrth::Parser.new(source)

    assert_equal(parser.get_word_raw, '."')
    assert_equal(parser.get_string, 'Testing 1 2 3')
  end

  #Test parsing nested comments.
  def test_parsing_comments
    test_string = '1 2 (Now we add them!) + .'
    source = XfOOrth::StringSource.new(test_string)
    parser = XfOOrth::Parser.new(source)

    assert_equal(parser.get_word_raw, '1')
    assert_equal(parser.get_word_raw, '2')
    assert_equal(parser.get_word_raw, '(')
    parser.skip_over_comment
    assert_equal(parser.get_word_raw, '+')
    assert_equal(parser.get_word_raw, '.')
    assert_equal(parser.get_word_raw, nil)
  end

  #Test parsing ill-nested comments.
  def test_parsing_bad_comments
    test_string = '1 2 (Now we add them! + .'
    source = XfOOrth::StringSource.new(test_string)
    parser = XfOOrth::Parser.new(source)

    assert_equal(parser.get_word_raw, '1')
    assert_equal(parser.get_word_raw, '2')
    assert_equal(parser.get_word_raw, '(')

    assert_raises(XfOOrth::XfOOrthError) do
      parser.skip_over_comment
    end
  end

  #Test parsing C++ style comments.
  def test_parsing_cpp_comments
    test_string = '1 2 //Now we add them!' + "\n" + '+ .'
    source = XfOOrth::StringSource.new(test_string)
    parser = XfOOrth::Parser.new(source)

    assert_equal(parser.get_word_raw, '1')
    assert_equal(parser.get_word_raw, '2')
    assert_equal(parser.get_word_raw, '//')
    parser.skip_to_eoln
    assert_equal(parser.get_word_raw, '+')
    assert_equal(parser.get_word_raw, '.')
    assert_equal(parser.get_word_raw, nil)
  end

  #Test parsing of words.
  def test_parse_word
    test_string = '1 2 //Now we add them!' + "\n" + '(Now add!) + (Now print!) .'
    source = XfOOrth::StringSource.new(test_string)
    parser = XfOOrth::Parser.new(source)

    assert_equal(parser.get_word, '1')
    assert_equal(parser.get_word, '2')
    assert_equal(parser.get_word, '+')
    assert_equal(parser.get_word, '.')
    assert_equal(parser.get_word, nil)
  end

end