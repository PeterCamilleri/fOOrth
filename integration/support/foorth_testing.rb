# coding: utf-8

#A small group of extensions to facilitate testing in fOOrth.
module XfOOrthTestExtensions

  #When the source is executed, is the stack as expected?
  #<br>Parameters:
  #* source - A string containing fOOrth source code to execute.
  #* remainder - An array with the expected stack contents after execution.
  #* debug - Set to true to display debug info.
  def foorth_equal(source, remainder=[], debug=false)
    vm = Thread.current[:vm]
    vm.debug = debug
    vm.process_string(source)
    assert_equal(remainder, vm.data_stack)
  ensure
    vm.debug = false
    vm.interpreter_reset
    vm.compiler_reset
  end

  #When the source is executed, does it raise err?
  #<br>Parameters:
  #* source - A string containing fOOrth source code to execute.
  #* err - The type of exception expected during execution.
  #* debug - Set to true to display debug info.
  def foorth_raises(source, err=XfOOrth::XfOOrthError, debug=false)
    vm = Thread.current[:vm]
    vm.debug = debug

    assert_raises(err) do
      vm.process_string(source)
    end
  ensure
    vm.debug = false
    vm.interpreter_reset
    vm.compiler_reset
  end

  #When the source is executed, does the stdout match?
  #<br>Parameters:
  #* source - A string containing fOOrth source code to execute.
  #* stdout_output - A string with the expected console output.
  def foorth_output(source, stdout_output)
    vm = Thread.current[:vm]

    assert_output(stdout_output) do
      vm.process_string(source)
    end
  ensure
    vm.interpreter_reset
    vm.compiler_reset
  end

end