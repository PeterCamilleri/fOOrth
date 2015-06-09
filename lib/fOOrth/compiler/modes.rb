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

    #Is entry into compile mode possible at this time?
    #<br>Returns:
    #* true if compile mode OK, else false.
    def query_compile_mode
      @context[:mode] == :execute
    end

    #Depending on the mode, process the text source code.
    #<br>Parameters:
    #* text - Some text to be executed or deferred.
    def process_text(text)
      dbg_puts "  Code=#{text.inspect}"

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
