# coding: utf-8

#* modes.rb - The control of the various compiler modes.
module XfOOrth

  #* modes.rb - The control of the various compiler modes.
  class VirtualMachine
    #Start compiling a fOOrth definition.
    #<br>Parameters
    #* ctrl - The control symbol that started the compilation.
    #* block - A block to be executed when the compilation is done.
    def begin_compile_mode(ctrl, &action)
      check_mode([:Execute])
      ctrl_push [ctrl, action, @level]
      @mode, @buffer, @level = :Compile, Word.preamble, @level+1
    end

    #Finish compiling a fOOrth definition.
    #<br>Parameters
    #* ctrls - an array of the allowed set of control values.
    def end_compile_mode(ctrls)
      check_all([:Compile], ctrls)
      check, action, level = ctrl_pop
      @buffer << POSTAMBLE

      puts "#{check} #{@buffer}" if @debug

      block = eval(@buffer)
      action.call(block)

      @mode, @buffer, @level = :Execute, nil, level
    end

    #While compiling, suspend compiling so that some code may be executed.
    #<br>Parameters
    #* ctrl - The control symbol that suspended the compilation.
    def suspend_compile_mode(ctrl)
      check_mode([:Compile])
      ctrl_push [ctrl, nil, level]
      @mode, @level = :Execute, @level+1
    end

    #While compiling and compiling is suspended, resume normal compiling.
    #<br>Parameters
    #* ctrls - An array of control symbols that could have
    #  suspended the compilation.
    def resume_compile_mode(ctrl)
      check_all([:Execute], ctrl)
      @mode, @level = :Compile, @level-1
      ctrl_pop
    end

    #Enter a mode where execution is deferred. If currently in :Execute
    #mode, enter :Deferred mode. If in :Compile mode, stay in that mode.
    #<br>Parameters
    #* ctrl - The control symbol that started the deferral.
    def suspend_execute_mode(ctrl)
      check_mode([:Compile, :Deferred, :Execute])
      ctrl_push [ctrl, @mode, @level]
      @level += 1

      if @mode == :Execute
        @mode   = :Deferred
        @buffer = Word.preamble
      end
    end

    #If execution was previously deferred, resume the previous mode.
    #<br>Parameters
    #* ctrls - An array of control symbols that could have started the deferral.
    def resume_execute_mode(ctrls)
      check_mode([:Compile, :Deferred])
      old_mode = @mode
      check, @mode, level = ctrl_pop
      @level -= 1
      check_ctrl(check, ctrls)
      check_level(level)

      if old_mode == :Deferred && @mode == :Execute
        @buffer << '}'
        puts "block: #{@buffer}" if @debug
        block = eval(@buffer)
        block.call(self)
        @buffer = nil
      end
    end

    #Ensure that the mode, control symbols, and nesting levels all agree
    #with the required values.
    #<br>Parameters
    #* modes - an array of the permissible operating modes.
    #* ctrls - an array of the allowed set of control values.
    def check_all(modes, ctrls)
      check_mode(modes)
      check, _temp, level = ctrl_peek
      check_ctrl(check, ctrls)
      check_level(level+1)
    end

    #Check that the compiler is in one of the expected modes.
    #<br>Parameters
    #* modes - an array of the permissible operating modes.
    def check_mode(modes)
      error "Compiler Mode Error: #{modes} vs #{@mode.inspect}" unless modes.include?(@mode)
    end

    #Check that the control symbol agrees with the expected value.
    #<br>Parameters
    #* check - the actual control value.
    #* ctrls - an array of the allowed set of control values.
    def check_ctrl(check, ctrls)
      error "Syntax Error #{ctrls} vs #{check}" unless ctrls.include?(check)
    end

    #Check that the nesting level agrees with the expected value.
    #<br>Parameters
    #* level - the computed nesting level, to be tested against
    #  the actual nesting level.
    def check_level(level)
      error "Nesting Error: #{@level} vs #{level}" if level != @level
    end

  end

end