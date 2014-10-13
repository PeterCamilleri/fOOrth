# coding: utf-8

require_relative '../../lib/fOOrth/exceptions'
require_relative '../../lib/fOOrth/monkey_patch/object'
require_relative '../../lib/fOOrth/symbol_map'
require_relative '../../lib/fOOrth/compiler/context'
require_relative '../../lib/fOOrth/compiler/word_specs'
require          'minitest/autorun'

class MockClass
  def initialize; @data = {}; end
  def []=(index, value); @data[index] = value; end
  def map_shared(index); @data[index]; end
end

class MockObject
  def initialize; @data = {}; end
  def []=(index, value); @data[index] = value; end
  def map_exclusive(index); @data[index]; end
end

#Test the monkey patches applied to the Object class.
class ContextTester < MiniTest::Unit::TestCase

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

  #Test that it can hold data.
  def test_data_store
    context = XfOOrth::Context.new(45, stuff: 'buy', price: :plenty)

    assert_equal(context.previous, 45)
    assert_equal(context[:stuff], 'buy')
    assert_equal(context[:price], :plenty)

    context[:stuff] = 'sell'
    assert_equal(context[:stuff], 'sell')
    assert_equal(context[:price], :plenty)

    context[:price] = 9.95
    assert_equal(context[:stuff], 'sell')
    assert_equal(context[:price], 9.95)
  end

  #Test level counting
  def test_level_tracking
    context = XfOOrth::Context.new(nil, stuff: 'buy')
    assert_equal(context.depth, 1)

    context = XfOOrth::Context.new(context, stuff: 'other')
    assert_equal(context.depth, 2)

    context = XfOOrth::Context.new(context, stuff: 'more')
    assert_equal(context.depth, 3)

    context = context.previous
    assert_equal(context.depth, 2)

    context = context.previous
    assert_equal(context.depth, 1)

    context = context.previous
    assert_equal(context, nil)
  end

  #Test symbol scoping
  def test_the_nesting_of_scopes
    context = XfOOrth::Context.new(nil, stuff: 'buy')
    assert_equal(context[:foo], nil)
    assert_equal(context[:jelly], nil)
    assert_equal(context[:stuff], 'buy')
    context[:foo] = 1
    context[:jelly] = 'donut'
    assert_equal(context[:jelly], 'donut')
    assert_equal(context[:stuff], 'buy')
    assert_equal(context[:foo], 1)

    context = XfOOrth::Context.new(context, stuff: 'other')
    assert_equal(context[:foo], 1)
    assert_equal(context[:jelly], 'donut')
    assert_equal(context[:stuff], 'other')
    context[:foo] = 2
    assert_equal(context[:jelly], 'donut')
    assert_equal(context[:stuff], 'other')
    assert_equal(context[:foo], 2)

    context = XfOOrth::Context.new(context, stuff: 'more')
    assert_equal(context[:foo], 2)
    assert_equal(context[:jelly], 'donut')
    assert_equal(context[:stuff], 'more')
    context[:foo] = 3
    context[:jelly] = 'Berliner'
    assert_equal(context[:jelly], 'Berliner')
    assert_equal(context[:stuff], 'more')
    assert_equal(context[:foo], 3)

    context = context.previous
    assert_equal(context[:foo], 2)
    assert_equal(context[:jelly], 'donut')
    assert_equal(context[:stuff], 'other')

    context = context.previous
    assert_equal(context[:foo], 1)
    assert_equal(context[:jelly], 'donut')
    assert_equal(context[:stuff], 'buy')
  end

  #Test the local mapping of symbols
  def test_the_local_mapping_of_symbols
    context = XfOOrth::Context.new(nil)

    name = 'b'
    sym = XfOOrth::SymbolMap.add_entry(name)
    context[sym] = XfOOrth::VmWordSpec.new(sym, name)
    spec = context.map(name)
    assert(spec.is_a?(XfOOrth::VmWordSpec))

    name = '@b'
    sym = XfOOrth::SymbolMap.add_entry(name)
    context[sym] = XfOOrth::VariableWordSpec.new(sym, name)
    spec = context.map(name)
    assert(spec.is_a?(XfOOrth::VariableWordSpec))

    name = '.b'
    sym = XfOOrth::SymbolMap.add_entry(name)
    context[sym] = XfOOrth::MethodWordSpec.new(sym, name)
    spec = context.map(name)
    assert(spec.is_a?(XfOOrth::MethodWordSpec))

    spec = context.map('~b')
    assert(spec.is_a?(XfOOrth::MethodWordSpec))
  end

  #Test the class instance mapping of symbols
  def test_the_class_mapping_of_symbols
    mk = MockClass.new
    context = XfOOrth::Context.new(nil, class: mk)

    name = 'c'
    sym = XfOOrth::SymbolMap.add_entry(name)
    mk[sym] = XfOOrth::MethodWordSpec.new(sym, name)
    spec = context.map(name)
    assert(spec.is_a?(XfOOrth::MethodWordSpec))

    name = '@c'
    sym = XfOOrth::SymbolMap.add_entry(name)
    mk[sym] = XfOOrth::VariableWordSpec.new(sym, name)
    spec = context.map(name)
    assert(spec.is_a?(XfOOrth::VariableWordSpec))

    name = '.c'
    sym = XfOOrth::SymbolMap.add_entry(name)
    mk[sym] = XfOOrth::MethodWordSpec.new(sym, name)
    spec = context.map(name)
    assert(spec.is_a?(XfOOrth::MethodWordSpec))

    spec = context.map('~c')
    assert(spec.is_a?(XfOOrth::MethodWordSpec))
  end

  #Test the singleton mapping of symbols
  def test_the_exclusive_mapping_of_symbols
    mk = MockObject.new
    context = XfOOrth::Context.new(nil, object: mk)

    name = 'd'
    sym = XfOOrth::SymbolMap.add_entry(name)
    mk[sym] = XfOOrth::MethodWordSpec.new(sym, name)
    spec = context.map(name)
    assert(spec.is_a?(XfOOrth::MethodWordSpec))

    name = '@d'
    sym = XfOOrth::SymbolMap.add_entry(name)
    mk[sym] = XfOOrth::VariableWordSpec.new(sym, name)
    spec = context.map(name)
    assert(spec.is_a?(XfOOrth::VariableWordSpec))

    name = '.d'
    sym = XfOOrth::SymbolMap.add_entry(name)
    mk[sym] = XfOOrth::MethodWordSpec.new(sym, name)
    spec = context.map(name)
    assert(spec.is_a?(XfOOrth::MethodWordSpec))

    spec = context.map('~d')
    assert(spec.is_a?(XfOOrth::MethodWordSpec))
  end


  #Test the mapping of symbols.
  def test_the_default_mapping_of_symbols
    context = XfOOrth::Context.new(nil)

    spec = context.map('test')
    assert_equal(spec, nil)

    XfOOrth::SymbolMap.add_entry('a')
    XfOOrth::SymbolMap.add_entry('@a')
    XfOOrth::SymbolMap.add_entry('$a')
    XfOOrth::SymbolMap.add_entry('.a')

    spec = context.map('a')
    assert(spec.is_a?(XfOOrth::VmWordSpec))

    spec = context.map('@a')
    assert(spec.is_a?(XfOOrth::VariableWordSpec))

    spec = context.map('$a')
    assert(spec.is_a?(XfOOrth::VariableWordSpec))

    spec = context.map('.a')
    assert(spec.is_a?(XfOOrth::MethodWordSpec))

    spec = context.map('~a')
    assert(spec.is_a?(XfOOrth::MethodWordSpec))
  end

  #Test verification testing.
  def test_that_it_verifies_sets
    context = XfOOrth::Context.new(nil, mode: :Execute, ctrl: :colon)

    assert(context.check_set(:mode, [:Execute, :Compile]))

    assert_raises(XfOOrth::XfOOrthError) do
      assert(context.check_set(:mode, [:Compile, :Deferred]))
    end

    assert(context.check_set(:stuff, [nil]))
  end

end