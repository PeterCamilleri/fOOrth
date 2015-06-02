# coding: utf-8

#* compiler/modes.rb - The control of the various compiler modes.
module XfOOrth
  #* modes.rb - The control of the various compiler modes.
  class VirtualMachine

    #Is entry into compile mode possible at this time?
    #<br>Returns:
    #* true if compile mode OK, else false.
    def query_compile_mode
      @context[:mode] == :execute
    end

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

    #Enter a delayed compile mode in which compilation is delayed till a
    #later time.
    def delayed_compile_mode(start)
      dbg_puts "  delayed_compile_mode"
      buffer, depth = start + ' ', 1

      while depth > 0
        if (word = parser.get_word_or_string)
          buffer << word + ' '
          depth += 1 if [':', '!:', '.:', '.::'].include?(word)
          depth -= 1 if word == ';'
        else
          error "F12: Error, Invalid compile nesting."
        end
      end

      buffer = "vm.process_string(#{buffer.foorth_embed}); "
      dbg_puts "  Append=#{buffer}"
      @buffer << buffer
    end

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

    #Enter a nested context without altering the current mode.
    #<br>Parameters:
    #* text - Some text to append associated with the nested state.
    #* ctrl - The control symbol that started the nested context.
    #<br>Note:
    #* Adds a nested context level to be un-nested at a later point.
    def nest_mode(text, ctrl)
      dbg_puts "  nest_context"
      @context = Context.new(@context, ctrl: ctrl)
      process_text(text)
    end

    #Leave a nested context without altering the current mode.
    #<br>Parameters:
    #* text - Some text to append associated with the nested state.
    #* ctrls - An array of control symbols that could have started the nest.
    #<br>Note:
    #* Removes a nested context level.
    def unnest_mode(text, ctrls)
      dbg_puts "  unnest_context"
      @context.check_set(:ctrl, ctrls)
      @context = @context.previous
      process_text(text)
    end

    #Depending on the mode, process the text source code.
    #<br>Parameters:
    #* text - Some text to be executed or deferred.
    def process_text(text)
      if execute_mode
        @context.recvr.instance_exec(self, &eval("lambda {|vm| #{text} }"))
      else
        self << text
      end
    end

    #Check to see if the virtual machine is in execute mode.
    def execute_mode
      @context[:mode] == :execute
    end

  end
end
