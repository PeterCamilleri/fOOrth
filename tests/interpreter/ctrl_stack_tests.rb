# coding: utf-8

require_relative '../../lib/fOOrth/interpreter'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class CtrlStackMapTester < MiniTest::Unit::TestCase

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  #Test control stack functionality.
  def test_control_stack_ops
    vm = Thread.current[:vm]
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