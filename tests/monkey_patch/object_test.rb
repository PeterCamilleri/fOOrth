# coding: utf-8

require_relative '../../lib/fOOrth/exceptions'
require_relative '../../lib/fOOrth/monkey_patch'
require          'minitest/autorun'

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

  #Test that it does NOT foorth_embed.
  def test_foorth_embed_error
    obj = Object.new
    assert_raises(XfOOrth::XfOOrthError) { obj.foorth_embed }
  end

  #Test for conversion to a boolean.
  def test_to_boolean
    obj = Object.new
    assert_equal(obj.to_foorth_b, true)
  end

  #Test for conversion to a character.
  def test_to_character
    obj = Object.new
    assert_equal(obj.to_foorth_c, "\x00")
  end

  #Test for conversion to a number.
  def test_to_number
    obj = Object.new
    assert_equal(obj.to_foorth_n, nil)
  end

  def test_to_pointer
    obj = Object.new
    assert_equal(obj.to_foorth_p, [obj])

    assert_equal((5).to_foorth_p, [5])
    assert_equal(('hello').to_foorth_p, ['hello'])
    assert_equal(nil.to_foorth_p, [nil])
  end

  #Test the quick fail raise in fOOrth.
  def test_that_exceptions_are_easy_to_raise
    assert_raises(XfOOrth::XfOOrthError) { error('Failure IS an option!') }
    assert_raises(XfOOrth::ForceAbort)   { abort('Aborting execution!') }
  end

  def test_mnmx_gt
    assert(('4').mnmx_gt('0'))
    refute(('4').mnmx_gt('4'))
    refute(('4').mnmx_gt('8'))
  end

  def test_mnmx_ge
    assert(('4').mnmx_ge('0'))
    assert(('4').mnmx_ge('4'))
    refute(('4').mnmx_ge('8'))
  end

  def test_mnmx_lt
    refute(('4').mnmx_lt('0'))
    refute(('4').mnmx_lt('4'))
    assert(('4').mnmx_lt('8'))
  end

  def test_mnmx_le
    refute(('4').mnmx_le('0'))
    assert(('4').mnmx_le('4'))
    assert(('4').mnmx_le('8'))
  end

  def test_mnmx_cp
    assert_equal( 1, ('4').mnmx_cp('0'))
    assert_equal( 0, ('4').mnmx_cp('4'))
    assert_equal(-1, ('4').mnmx_cp('8'))
  end

end
