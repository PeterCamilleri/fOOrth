# coding: utf-8

require_relative '../../lib/fOOrth/exceptions'
require_relative '../../lib/fOOrth/monkey_patch/object'
require          'minitest/autorun'

#A tiny test class used to test access to instance variables.
class Test
  def initialize
    @my_var = 'before'
  end
end


#Test the monkey patches applied to the Object class.
class ObjectMonkeyPatchTester < MiniTest::Unit::TestCase

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

  #Test that it does NOT embed.
  def test_embed
    obj = Object.new
    assert_raises(XfOOrth::XfOOrthError) { obj.embed }
  end

  #Test for conversion to a boolean.
  def test_to_boolean
    obj = Object.new
    assert(obj == obj.to_fOOrth_b)
  end

  #Test for conversion to a character.
  def test_to_character
    obj = Object.new
    assert_equal(obj.to_fOOrth_c, "\x00")
  end

  #Test for conversion to a number.
  def test_to_number
    obj = Object.new
    assert_equal(obj.to_fOOrth_n, nil)
  end

  #Test the quick fail raise in fOOrth.
  def test_that_exceptions_are_easy_to_raise
    assert_raises(XfOOrth::XfOOrthError) { error('Failure IS an option!') }
    assert_raises(XfOOrth::ForceAbort)   { abort('Aborting execution!') }
  end

  #Test that the instance variable aliases are correctly defined.
  def test_instance_var_aliases
    test = Test.new

    assert_equal(test.read_var(:@my_var), "before")
    test.write_var(:@my_var, "after")
    assert_equal(test.read_var(:@my_var), "after")
  end

end