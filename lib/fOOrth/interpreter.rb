# coding: utf-8

require_relative 'interpreter/data_stack'

#* interpreter.rb - The run time interpreter portion of the fOOrth language system.
module XfOOrth

  class VirtualMachine

    #The fOOrth control stack. This is mostly used to hold information
    #relating to control structures during compile and interpretation.
    attr_reader :ctrl_stack

    #Reset the state of the fOOrth inner interpreter.
    def interpreter_reset
      @data_stack   = Array.new
      @ctrl_stack   = Array.new
      @start_time   = Time.now
    end
  end

end
