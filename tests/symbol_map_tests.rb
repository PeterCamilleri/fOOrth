# coding: utf-8

require_relative '../lib/foorth/exceptions'
require_relative '../lib/foorth/monkey_patch/object'
require_relative '../lib/foorth/symbol_map'
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
    Xfoorth::SymbolMap.restart('test_10')

    assert_equal(Xfoorth::SymbolMap.add_entry('foo'), :test_11)
    assert_equal(Xfoorth::SymbolMap.add_entry('bar'), :test_12)
    assert_equal(Xfoorth::SymbolMap.add_entry('foo'), :test_11)

    assert_equal(Xfoorth::SymbolMap.map('foo'), :test_11)
    assert_equal(Xfoorth::SymbolMap.map('goo'), nil)

    assert_equal(Xfoorth::SymbolMap.unmap(:test_11), 'foo')
    assert_equal(Xfoorth::SymbolMap.unmap(:test_12), 'bar')
    assert_equal(Xfoorth::SymbolMap.unmap(:test_ikle), nil)
  end

  #Test the special mappings facility
  def test_special_mappings
    assert_equal(Xfoorth::SymbolMap.add_special('init', :init), :init)
    assert_equal(Xfoorth::SymbolMap.add_special('init', :init), :init)

    assert_equal(Xfoorth::SymbolMap.map('init'), :init)

    assert_equal(Xfoorth::SymbolMap.unmap(:init), 'init')

    assert_raises(Xfoorth::XfoorthError) do
      Xfoorth::SymbolMap.add_special('init', :evil)
    end
  end

end