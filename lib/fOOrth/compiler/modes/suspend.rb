# coding: utf-8

#* compiler/modes/suspend.rb - The ability to suspend buffered mode.
module XfOOrth
  #* compiler/modes/suspend.rb - The ability to suspend buffered mode.
  class VirtualMachine

    #While compiling, suspend compiling so that some code may be executed.
    #<br>Parameters:
    #* ctrl - The control symbol that suspended the compilation.
    #<br>Note:
    #* Adds a nested context level to be un-nested at a later point.
    def suspend_buffered_mode(ctrl)
      dbg_puts "  suspend_buffered_mode"

      unless buffer_valid?
        error "F14: The #{ctrl} method is not available in execute mode."
      end

      @context = Context.new(@context, mode: :execute, ctrl: ctrl)
    end

    #While compiling and compiling is suspended, resume normal compiling.
    #<br>Parameters:
    #* ctrls - An array of control symbols that could have
    #  suspended the compilation.
    #<br>Note:
    #* Un-nests a context level.
    def resume_buffered_mode(ctrls)
      dbg_puts "  resume_buffered_mode"
      @context.check_set(:ctrl, ctrls)
      @context = @context.previous
    end

  end
end
