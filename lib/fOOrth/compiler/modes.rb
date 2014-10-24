# coding: utf-8

#* compiler/modes.rb - The control of the various compiler modes.
module XfOOrth
  #* modes.rb - The control of the various compiler modes.
  class VirtualMachine

    #Start compiling a fOOrth definition.
    #<br>Parameters
    #* ctrl - The control symbol that started the compilation.
    #* action - A block to be executed when the compilation is done.
    #<br>Note:
    #* Adds a nested context level to be un-nested at a later point.
    def begin_compile_mode(ctrl, &action)
      puts "  begin_compile_mode" if debug
      @context.check_set(:mode, [:execute])
      @context = Context.new(@context, mode: :compile, ctrl: ctrl, action: action)
      @buffer = ''
    end

    #Finish compiling a fOOrth definition.
    #<br>Parameters
    #* ctrls - an array of the allowed set of control values.
    #<br>Returns
    #* The value of the action block.
    #<br>Note:
    #* Un-nests a context level.
    def end_compile_mode(ctrls)
      puts "  end_compile_mode" if debug
      @context.check_set(:ctrl, ctrls)
      @context.check_set(:mode, [:compile])
      result = instance_exec(self, "lambda {|vm| #{@buffer}}", &@context[:action])
      @context = @context.previous
      result
    end

    #While compiling, suspend compiling so that some code may be executed.
    #<br>Parameters
    #* ctrl - The control symbol that suspended the compilation.
    #<br>Note:
    #* Adds a nested context level to be un-nested at a later point.
    def suspend_compile_mode(ctrl)
      puts "  suspend_compile_mode" if debug
      @context.check_set(:mode, [:compile, :deferred])
      @context = Context.new(@context, mode: :execute, ctrl: ctrl)
    end

    #While compiling and compiling is suspended, resume normal compiling.
    #<br>Parameters
    #* ctrls - An array of control symbols that could have
    #  suspended the compilation.
    #<br>Note:
    #* Un-nests a context level.
    def resume_compile_mode(ctrls)
      puts "  resume_compile_mode" if debug
      @context.check_set(:ctrl, ctrls)
      @context.check_set(:mode, [:execute])
      @context = @context.previous
    end

    #Enter a mode where execution is deferred. If currently in :execute
    #mode, enter :deferred mode else the mode is unchanged.
    #<br>Parameters
    #* text - Some text to append to the buffer before proceeding.
    #* ctrl - The control symbol that started the deferral.
    #<br>Note:
    #* Adds a nested context level to be un-nested at a later point.
    def suspend_execute_mode(text, ctrl)
      puts "  suspend_execute_mode" if debug
      @context = Context.new(@context, ctrl: ctrl)

      if @context[:mode] == :execute
        @context[:mode] = :deferred
        @buffer = ''
      end

      self << text
    end

    #Verify the deferred execution state.
    #<br>Parameters
    #* text - Some text to append to the buffer before bundling it up.
    #* ctrls - An array of control symbols that could have started the deferral.
    def check_deferred_mode(text, ctrls)
      @context.check_set(:ctrl, ctrls)
      @context.check_set(:mode, [:compile, :deferred])
      self << text
    end

    #If execution was previously deferred, resume the previous mode.
    #<br>Parameters
    #* text - Some text to append to the buffer before bundling it up.
    #* ctrls - An array of control symbols that could have started the deferral.
    #<br>Note:
    #* Un-nests a context level.
    def resume_execute_mode(text, ctrls)
      puts "  resume_execute_mode" if debug
      check_deferred_mode(text, ctrls)
      @context = @context.previous

      if @context[:mode] == :execute
        source, @buffer = "lambda {|vm| #{@buffer} }", nil
        instance_exec(self, &eval(source))
      end
    end
  end
end
