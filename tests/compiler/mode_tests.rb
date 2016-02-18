# coding: utf-8

$exclude_fOOrth_library = true
require_relative '../../lib/fOOrth'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class CompilerModeTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def test_mode_nesting
    #Get the virtual machine.
    vm = Thread.current[:vm]
    vm.interpreter_reset
    vm.compiler_reset

    #Test the baseline assumptions.
    assert_equal(vm.context.depth, 1)

    #Nest in by one level.
    vm.nest_mode("", "[")
    assert_equal(vm.context.depth, 2)

    #Back off nesting by one level.
    vm.unnest_mode("", ["["])
    assert_equal(vm.context.depth, 1)
  end

  def test_ill_nesting
    #Get the virtual machine.
    vm = Thread.current[:vm]
    vm.interpreter_reset
    vm.compiler_reset

    #Nest in by one level.
    vm.nest_mode("", "[")

    #Back off nesting by one level with wrong tag.
    assert_raises(XfOOrth::XfOOrthError) { vm.unnest_mode("", ["{"]) }
  end

end
