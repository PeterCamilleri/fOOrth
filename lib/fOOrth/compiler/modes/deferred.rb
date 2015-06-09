# coding: utf-8

#* compiler/modes.rb - The control of the various compiler modes.
module XfOOrth
  #* modes.rb - The control of the various compiler modes.
  class VirtualMachine

    #Enter a mode where execution is deferred. If currently in :execute mode,
    #enter :deferred mode else the mode is unchanged. This is used by words
    #that need to group words together to work like if, do, and begin.
    #<br>Parameters:
    #* text - Some text to append to the buffer before proceeding.
    #* ctrl - The control symbol that started the deferral.
    #<br>Note:
    #* Adds a nested context level to be un-nested at a later point.
    def suspend_execute_mode(text, ctrl)
      dbg_puts "  suspend_execute_mode"
      @context = Context.new(@context, ctrl: ctrl)

      if execute_mode
        @context[:mode] = :deferred
        @buffer = ''
      end

      self << text
    end

    #Verify the deferred execution state. This are used by words that work
    #within a word grouping like else or while.
    #<br>Parameters:
    #* text - Some text to append to the buffer before bundling it up.
    #* ctrls - An array of control symbols that could have started the deferral.
    def check_deferred_mode(text, ctrls)
      @context.check_set(:ctrl, ctrls)
      self << text
    end

    #If execution was previously deferred, resume the previous mode. This is
    #used in words that close off a block action like then, loop, or repeat.
    #<br>Parameters:
    #* text - Some text to append to the buffer before bundling it up.
    #* ctrls - An array of control symbols that could have started the deferral.
    #<br>Note:
    #* Un-nests a context level.
    def resume_execute_mode(text, ctrls)
      dbg_puts "  resume_execute_mode"
      check_deferred_mode(text, ctrls)
      @context = @context.previous

      if @context[:mode] == :execute
        source, @buffer = "lambda {|vm| #{@buffer} }", nil
        instance_exec(self, &eval(source))
      end
    end

  end
end
