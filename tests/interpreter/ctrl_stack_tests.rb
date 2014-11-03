# coding: utf-8

gem              'minitest'
require          'minitest/autorun'
require_relative '../../lib/fOOrth/interpreter'

#Test the monkey patches applied to the Object class.
class CtrlStackMapTester < MiniTest::Test

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

  #Test control stack functionality.
  def test_control_stack_ops
    vm = XfOOrth.virtual_machine
    refute(vm == nil)

    vm.interpreter_reset

    assert_equal(vm.ctrl_stack, [])
    vm.ctrl_push(4)
    assert_equal(vm.ctrl_stack, [4])
    vm.ctrl_push(8)
    assert_equal(vm.ctrl_stack, [4, 8])
    assert_equal(vm.ctrl_peek, 8)
    assert_equal(vm.ctrl_peek(1), 8)
    assert_equal(vm.ctrl_peek(2), 4)
    assert_equal(vm.ctrl_pop, 8)
    assert_equal(vm.ctrl_stack, [4])
    assert_equal(vm.ctrl_pop, 4)
    assert_equal(vm.ctrl_stack, [])


  end

end