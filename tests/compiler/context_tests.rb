# coding: utf-8

$exclude_fOOrth_library = true
require_relative '../../lib/fOOrth'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class MockClass
  def initialize; @data = {}; end
  def []=(index, value); @data[index] = value; end
  def map_foorth_shared(index); @data[index]; end
end

class MockObject
  def initialize; @data = {}; end
  def []=(index, value); @data[index] = value; end
  def map_foorth_exclusive(index); @data[index]; end
end

#Test the monkey patches applied to the Object class.
class ContextTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

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
    assert_nil(context)
  end

  def test_the_nesting_of_scopes
    context = XfOOrth::Context.new(nil, stuff: 'buy')
    assert_nil(context[:foo])
    assert_nil(context[:jelly])
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

  def test_the_local_mapping_of_symbols
    context = XfOOrth::Context.new(nil)

    name = 'b'
    sym = XfOOrth::SymbolMap.add_entry(name)
    context[sym] = XfOOrth::VmSpec.new(name, sym, [])
    spec = context.map_with_defaults(name)
    assert(spec.is_a?(XfOOrth::VmSpec))
  end

  def test_the_class_mapping_of_symbols
    mk = MockClass.new
    context = XfOOrth::Context.new(nil, cls: mk)

    name = '.c'
    sym = XfOOrth::SymbolMap.add_entry(name)
    mk[sym] = XfOOrth::TosSpec.new(name, sym, [])
    spec = context.map_with_defaults(name)
    assert(spec.is_a?(XfOOrth::TosSpec))
  end

  def test_the_exclusive_mapping_of_symbols
    mk = MockObject.new
    context = XfOOrth::Context.new(nil, obj: mk)

    name = '.d'
    sym = XfOOrth::SymbolMap.add_entry(name)
    mk[sym] = XfOOrth::TosSpec.new(name, sym, [])
    spec = context.map_with_defaults(name)
    assert(spec.is_a?(XfOOrth::TosSpec))
  end

  def test_that_it_verifies_sets
    context = XfOOrth::Context.new(nil, mode: :Execute, ctrl: :colon)

    assert(context.check_set(:mode, [:Execute, :Compile]))

    assert_raises(XfOOrth::XfOOrthError) do
      context.check_set(:mode, [:Compile, :Deferred])
    end

    assert(context.check_set(:stuff, [nil]))
  end

  def test_the_locating_of_the_receiver
    context = XfOOrth::Context.new(nil, vm: 'vm_sample')
    assert_equal('vm_sample', context.target)

    context = XfOOrth::Context.new(context, cls: 'cls_sample')
    assert_equal('cls_sample', context.target)

    context = XfOOrth::Context.new(context, obj: 'obj_sample')
    assert_equal('obj_sample', context.target)

    context = XfOOrth::Context.new(nil)
    assert_raises(XfOOrth::XfOOrthError) { context.target }
  end

  def test_adding_and_removing_local_methods
    context = XfOOrth::Context.new(nil, vm: 'vm_sample')
    name = 'lm'
    sym = XfOOrth::SymbolMap.add_entry(name)
    spec = context.create_local_method(name, XfOOrth::LocalSpec, [])

    assert_equal(spec, context[sym])

    context.remove_local_method(name)

    assert_nil(context[sym])

  end

end
