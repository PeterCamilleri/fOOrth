require_relative '../lib/foorth'

#A small group of extensions to facilitate testing in fOOrth.
module XfOOrthTestExtensions

  def foorth_assert(source, remainder=[])
    vm = XfOOrth.virtual_machine
    vm.process_string(source)
    assert(vm.pop?)
    assert_equal(remainder, vm.data_stack)
  ensure
    vm.interpreter_reset
  end

  def foorth_refute(source, remainder=[])
    vm = XfOOrth.virtual_machine
    vm.process_string(source)
    refute(vm.pop?)
    assert_equal(remainder, vm.data_stack)
  ensure
    vm.interpreter_reset
  end

  def foorth_equal(source, remainder=[])
    vm = XfOOrth.virtual_machine
    vm.process_string(source)
    assert_equal(remainder, vm.data_stack)
  ensure
    vm.interpreter_reset
  end

  def assert_raises(source, err=XfOOrth::XfOOrthError)
    vm = XfOOrth.virtual_machine

    assert_raises(err) do
      vm.process_string(source)
    end
  ensure
    vm.interpreter_reset
  end

end