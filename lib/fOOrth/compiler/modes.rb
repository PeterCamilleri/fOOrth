# coding: utf-8

#* compiler/modes.rb - The control of the various compiler modes.
module XfOOrth
  #* modes.rb - The control of the various compiler modes.
  class VirtualMachine

    #Start compiling a fOOrth definition.
    #<br>Parameters
    #* ctrl - The control symbol that started the compilation.
    #* action - A block to be executed when the compilation is done.
    def begin_compile_mode(ctrl, &action)
      @context.check_set(:mode, [:execute])
      @context = Context.new(@context,
        mode: :compile, ctrl: ctrl, action: action)
    end

    #Finish compiling a fOOrth definition.
    #<br>Parameters
    #* ctrls - an array of the allowed set of control values.
    def end_compile_mode(ctrls)
      @context.check_set(:mode, [:compile])
      @context.check_set(:ctrl, ctrls)

      block = eval("lambda {|vm| #{@buffer} }")
      instance_exec(block, &@context[:action])

      @context = @context.previous
    end

    #While compiling, suspend compiling so that some code may be executed.
    #<br>Parameters
    #* ctrl - The control symbol that suspended the compilation.
    def suspend_compile_mode(ctrl)
      @context.check_set(:mode, [:compile, :deffered])
      @context = Context.new(@context, mode: :execute, ctrl: ctrl)
    end

    #While compiling and compiling is suspended, resume normal compiling.
    #<br>Parameters
    #* ctrls - An array of control symbols that could have
    #  suspended the compilation.
    def resume_compile_mode(ctrls)
      @context.check_set(:mode, [:execute])
      @context.check_set(:ctrl, ctrls)
      @context = @context.previous
    end

    #Enter a mode where execution is deferred. If currently in :Execute
    #mode, enter :Deferred mode. If in :Compile mode, stay in that mode.
    #<br>Parameters
    #* ctrl - The control symbol that started the deferral.
    def suspend_execute_mode(ctrl)
      @context = Context.new(@context, ctrl: ctrl)

      if @context[:mode] == :execute
        @context[:mode] = :deferred
        @buffer = ''
      end
    end

    #If execution was previously deferred, resume the previous mode.
    #<br>Parameters
    #* ctrls - An array of control symbols that could have started the deferral.
    def resume_execute_mode(ctrls)
      @context.check_set(:mode, [:compile, :deffered])
      @context.check_set(:ctrl, ctrls)
      @context = @context.previous

      if @context[:mode] == :execute
        instance_exec(self, &eval("lambda {|vm| #{@buffer} }"))
        @buffer = nil
      end
    end

  end
end
