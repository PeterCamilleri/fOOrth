# coding: utf-8

require_relative '../../lib/foorth/monkey_patch/string'
require          'minitest/autorun'

#Test the monkey patches applied to the Object class.
class StringMonkeyPatchTester < MiniTest::Unit::TestCase

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

  #Test that it embeds
  def test_embed
    assert_equal("cat".embed, "'cat'")
    assert_equal("'cat".embed, "'\\'cat'")
    assert_equal('\cat'.embed, "'\\cat'")
  end

  #Test converting to a boolean.
  def test_to_boolean
    assert('cat'.to_foorth_b)
    refute(''.to_foorth_b)
  end

  #Test converting to a character.
  def test_to_character
    assert_equal('ABC'.to_foorth_c, 'A')
  end

  #Test converting to a number.
  def test_to_number
    assert_equal('123'.to_foorth_n,   123)
    assert_equal('123.4'.to_foorth_n, 123.4)
    assert_equal('1/2'.to_foorth_n, '1/2'.to_r)
    assert_equal('1+2i'.to_foorth_n, Complex(1,2))
  end

end