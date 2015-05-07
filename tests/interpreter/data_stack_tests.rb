# coding: utf-8

require_relative '../../lib/fOOrth/interpreter'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class DataStackMapTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_data_stack_ops
    vm = Thread.current[:vm]
    refute(vm == nil)

    vm.interpreter_reset

    assert_equal(vm.data_stack, [])
    vm.push(4)
    assert_equal(vm.data_stack, [4])
    vm.push(8)
    assert_equal(vm.data_stack, [4, 8])
    assert_equal(vm.peek, 8)
    assert_equal(vm.peek(1), 8)
    assert_equal(vm.peek(2), 4)
    assert_equal(vm.pop, 8)
    assert_equal(vm.data_stack, [4])
    assert_equal(vm.pop, 4)
    assert_equal(vm.data_stack, [])

    vm.push(8)
    assert_equal(vm.data_stack, [8])
    vm.pushm([1,2,3])
    assert_equal(vm.data_stack, [8, 1, 2, 3])

    assert_raises(XfOOrth::XfOOrthError) do
      vm.peek(-1)
    end
  end

  def test_boolean_stack_data
    vm = Thread.current[:vm]
    refute(vm == nil)

    vm.interpreter_reset

    vm.push(16)
    assert(vm.pop?)

    vm.push(true)
    assert(vm.pop?)

    vm.push('test')
    assert(vm.pop?)

    vm.push(0)
    assert(vm.pop?)

    vm.push(false)
    refute(vm.pop?)

    vm.push('')
    assert(vm.pop?)

    vm.push(nil)
    refute(vm.pop?)
  end

  def test_pop_multiple
    vm = Thread.current[:vm]
    refute(vm == nil)

    vm.interpreter_reset

    vm.push(16)
    vm.push(true)
    vm.push('test')
    vm.push(0)
    vm.push('')
    vm.push(nil)

    assert_equal(vm.data_stack, [16, true, 'test', 0, '', nil])
    assert_equal(vm.popm(3), [0, '', nil])
    assert_equal(vm.popm(3), [16, true, 'test'])
    assert_equal(vm.data_stack, [])
  end

  def test_poke
    vm = Thread.current[:vm]
    refute(vm == nil)

    vm.interpreter_reset

    vm.push(42)
    vm.poke("hello")
    assert_equal(vm.data_stack, ["hello"])
  end

  def test_swap_pop
    vm = Thread.current[:vm]
    refute(vm == nil)

    vm.interpreter_reset

    vm.push(16)
    vm.push(99)
    assert_equal(vm.swap_pop, 16)
    assert_equal(vm.pop, 99)
    assert_equal(vm.data_stack, [])
  end

end