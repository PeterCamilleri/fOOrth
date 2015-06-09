# coding: utf-8

#* compiler/modes.rb - The control of the various compiler modes.
module XfOOrth
  #* modes.rb - The control of the various compiler modes.
  class VirtualMachine

    #While compiling, suspend compiling so that some code may be executed.
    #<br>Parameters:
    #* ctrl - The control symbol that suspended the compilation.
    #<br>Note:
    #* Adds a nested context level to be un-nested at a later point.
    def suspend_compile_mode(ctrl)
      dbg_puts "  suspend_compile_mode"
      @context.check_set(:mode, [:compile])
      @context = Context.new(@context, mode: :execute, ctrl: ctrl)
    end

    #While compiling and compiling is suspended, resume normal compiling.
    #<br>Parameters:
    #* ctrls - An array of control symbols that could have
    #  suspended the compilation.
    #<br>Note:
    #* Un-nests a context level.
    def resume_compile_mode(ctrls)
      dbg_puts "  resume_compile_mode"
      @context.check_set(:ctrl, ctrls)
      @context = @context.previous
    end

  end
end
