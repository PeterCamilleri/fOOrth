# coding: utf-8

#* compiler/modes.rb - The control of the various compiler modes.
module XfOOrth
  #* modes.rb - The control of the various compiler modes.
  class VirtualMachine

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

  end
end
