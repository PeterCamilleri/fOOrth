# coding: utf-8

require_relative '../../lib/fOOrth/interpreter'
require          'minitest/autorun'

#Test the monkey patches applied to the Object class.
class DataStackMapTester < MiniTest::Unit::TestCase

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
    refute(vm.pop?)

    vm.push(false)
    refute(vm.pop?)

    vm.push('')
    refute(vm.pop?)

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