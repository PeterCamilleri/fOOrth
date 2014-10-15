# coding: utf-8

require_relative '../lib/fOOrth/exceptions'
require_relative '../lib/fOOrth/monkey_patch/object'
require_relative '../lib/fOOrth/symbol_map'
require          'minitest/autorun'

#Test the monkey patches applied to the Object class.
class SymbolMapTester < MiniTest::Unit::TestCase

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

  #Test that we can add, map, and un-map names.
  def test_adding_mappings
    XfOOrth::SymbolMap.restart('test_10')
    assert_equal(XfOOrth::SymbolMap.add_entry('foo'), :test_11)
    assert_equal(XfOOrth::SymbolMap.add_entry('bar'), :test_12)
    assert_equal(XfOOrth::SymbolMap.add_entry('foo'), :test_11)
    assert_equal(XfOOrth::SymbolMap.map('foo'), :test_11)
    refute(XfOOrth::SymbolMap.map('goo'))
    assert_equal(XfOOrth::SymbolMap.unmap(:test_11), ['foo'])
    assert_equal(XfOOrth::SymbolMap.unmap(:test_12), ['bar'])
    refute(XfOOrth::SymbolMap.unmap(:test_ikle))

    assert_raises(XfOOrth::XfOOrthError) do
      XfOOrth::SymbolMap.add_entry('foo', :evil_method)
    end

  end

  #Test the special mappings facility
  def test_special_mappings
    assert_equal(XfOOrth::SymbolMap.map('.init'), :foorth_init)
    assert_equal(XfOOrth::SymbolMap.unmap(:foorth_init), ['.init'])

    assert_raises(XfOOrth::XfOOrthError) do
      XfOOrth::SymbolMap.add_entry('.init', :evil_method)
    end
  end

  #Test mapping with . and ~
  def test_mapping_with_dot_and_tilde
    XfOOrth::SymbolMap.restart('test_20')
    assert_equal(XfOOrth::SymbolMap.add_entry('.foo'), :test_21)
    assert_equal(XfOOrth::SymbolMap.map('.foo'), :test_21)
    assert_equal(XfOOrth::SymbolMap.map('~foo'), :test_21)
  end
end
