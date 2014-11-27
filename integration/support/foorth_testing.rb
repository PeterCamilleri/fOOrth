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

  #Copied here for study
  def capture_foorth_io
    require 'stringio'

    orig_stdout, orig_stderr         = $stdout, $stderr

    (s_o = StringIO.new).set_encoding 'UTF-8'
    captured_stdout, captured_stderr = s_o, StringIO.new
    $stdout, $stderr                 = captured_stdout, captured_stderr

    yield

    return captured_stdout.string.bytes.to_a, captured_stderr.string
  ensure
    $stdout = orig_stdout
    $stderr = orig_stderr
  end

  #Copied here for study
  def assert_foorth_output(stdout = nil, stderr = nil)
    out, err = capture_foorth_io do
      yield
    end

    x = assert_equal stdout, out, "In stdout" if stdout
    y = assert_equal stderr, err, "In stderr" if stderr

    (!stdout || x) && (!stderr || y)
  end

  #When the source is executed, does the stdout match? Special!
  #<br>Parameters:
  #* source - A string containing fOOrth source code to execute.
  #* stdout_output - An array of bytes expected from the console.
  def foorth_alt_output(source, stdout_output)
    vm = Thread.current[:vm]

    assert_foorth_output(stdout_output) do
      vm.process_string(source)
    end
  ensure
    vm.interpreter_reset
    vm.compiler_reset
  end

end