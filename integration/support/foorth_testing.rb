# coding: utf-8

#A small group of extensions to facilitate testing in fOOrth.
module XfOOrthTestExtensions

  #When the source is executed, does it raise err?
  #<br>Parameters:
  #* source - A string containing fOOrth source code to execute.
  #* err - The type of exception expected during execution.
  #* debug - Set to true to display debug info.
  def foorth_run(source, debug=false)
    vm = Thread.current[:vm]
    vm.debug = debug
    vm.process_string(source)
  ensure
    vm.debug = false
    vm.interpreter_reset
    vm.compiler_reset
  end

  #When the source is executed, is the stack as expected?
  #<br>Parameters:
  #* source - A string containing fOOrth source code to execute.
  #* remainder - An array with the expected stack contents after execution.
  #* debug - Set to true to display debug info.
  def foorth_equal(source, remainder=[], debug=false)
    self.assertions += 1
    vm = Thread.current[:vm]
    vm.debug = debug
    vm.process_string(source)

    unless remainder == vm.data_stack
      msg = "Expected: #{remainder.inspect}\nActual: #{vm.data_stack.inspect}"
      raise MiniTest::Assertion, msg, caller
    end
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
    self.assertions += 1
    vm = Thread.current[:vm]
    vm.debug = debug
    failed, msg = false, ""

    begin
      vm.process_string(source)
      msg = "Expected: #{err}\nActual: No exception raised."
      failed = true

    rescue Exception => e
      unless e.class == err
        msg = "Expected: #{err}\nActual: #{e.class}"
        failed = true
      end
    end

    raise MiniTest::Assertion, msg, caller if failed

  ensure
    vm.debug = false
    vm.interpreter_reset
    vm.compiler_reset
  end

  #When the source is executed, does the stdout match?
  #<br>Parameters:
  #* source - A string containing fOOrth source code to execute.
  #* expected - A string with the expected console output.
  def foorth_output(source, expected)
    self.assertions += 1
    failed, msg = false, ""
    vm = Thread.current[:vm]

    actual, _nc = capture_io do
      vm.process_string(source)
    end

    if expected != actual
      msg = "Expected: #{expected.inspect}\nActual: #{actual.inspect}"
      raise MiniTest::Assertion, msg, caller
    end

  ensure
    vm.interpreter_reset
    vm.compiler_reset
  end

  #Copied here for study
  def capture_foorth_io
    require 'stringio'

    orig_stdout = $stdout

    (s_o = StringIO.new).set_encoding 'UTF-8'
    captured_stdout = s_o
    $stdout = captured_stdout

    yield

    return captured_stdout.string.bytes.to_a
  ensure
    $stdout = orig_stdout
  end

  #When the source is executed, does the stdout match? Forces UTF-8 encoding.
  #<br>Parameters:
  #* source - A string containing fOOrth source code to execute.
  #* expected - An array of bytes expected for the console.
  def foorth_utf8_output(source, expected)
    self.assertions += 1
    vm = Thread.current[:vm]

    actual = capture_foorth_io do
      vm.process_string(source)
    end

    if expected != actual
      msg = "Expected: #{expected.inspect}\nActual: #{actual.inspect}"
      raise MiniTest::Assertion, msg, caller
    end

  ensure
    vm.interpreter_reset
    vm.compiler_reset
  end

end