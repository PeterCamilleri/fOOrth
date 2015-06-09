# coding: utf-8

#* compiler/modes/compiled.rb - The compiled system mode.
module XfOOrth
  #* modes.rb - The control of the various compiler modes.
  class VirtualMachine

    #Start compiling a fOOrth definition. This is used to get things going
    #by the various compiling words like ':', '::', ':::', etc.
    #<br>Parameters:
    #* ctrl - The control symbol that started the compilation.
    #* action - A block to be executed when the compilation is done.
    #<br>Note:
    #* Adds a nested context level to be un-nested at a later point.
    def begin_compile_mode(ctrl, defs={}, &action)
      dbg_puts "  begin_compile_mode"
      @context.check_set(:mode, [:execute])
      @context = Context.new(@context, mode: :compile, ctrl: ctrl, action: action)
      @context.merge(defs)
      @buffer = ''
    end

    #Finish compiling a fOOrth definition. This is used to wrap things up,
    #mostly by the semi-colon ';' word.
    #<br>Parameters:
    #* ctrls - an array of the allowed set of control values.
    #<br>Returns:
    #* The value of the action block.
    #<br>Note:
    #* Un-nests a context level.
    def end_compile_mode(ctrls)
      @context.check_set(:ctrl, ctrls)
      source, @buffer = "lambda {|vm| #{@buffer} }", nil
      result = instance_exec(self, source, @context.tags, &@context[:action])
      @context = @context.previous
      dbg_puts "  end_compile_mode"
      result
    end

  end
end
