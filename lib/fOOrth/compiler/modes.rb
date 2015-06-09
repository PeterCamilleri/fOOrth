# coding: utf-8

require_relative 'modes/compiled'
require_relative 'modes/suspend'
require_relative 'modes/delayed'
require_relative 'modes/deferred'
require_relative 'modes/nested'

#* compiler/modes.rb - The control of the various compiler modes.
module XfOOrth
  #* modes.rb - The control of the various compiler modes.
  class VirtualMachine

    #Depending on the mode, process the text source code.
    #<br>Parameters:
    #* text - Some text to be executed or deferred.
    def process_text(text)
      if execute_mode
        dbg_puts "  Code=#{text.inspect}"
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
