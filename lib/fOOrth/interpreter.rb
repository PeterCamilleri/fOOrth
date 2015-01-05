# coding: utf-8

require_relative 'interpreter/data_stack'
require_relative 'interpreter/ctrl_stack'
require_relative 'interpreter/do_loop'
require_relative 'interpreter/squash'
require_relative 'interpreter/add_to_hash'

#* interpreter.rb - The run time interpreter portion of the fOOrth language system.
module XfOOrth

  #* interpreter.rb - The run time interpreter portion of the fOOrth language system.
  class VirtualMachine

    #Reset the state of the fOOrth inner interpreter.
    def interpreter_reset
      @data_stack   = Array.new
      @ctrl_stack   = Array.new
      @start_time   = Time.now
    end
  end

end
