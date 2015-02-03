# coding: utf-8

require_relative 'interpreter/data_stack'
require_relative 'interpreter/do_loop'
require_relative 'interpreter/squash'
require_relative 'interpreter/add_to_hash'

#* interpreter.rb - The run time interpreter portion of the fOOrth language system.
module XfOOrth

  #* interpreter.rb - The run time interpreter portion of the fOOrth language system.
  class VirtualMachine

    #The fOOrth timer anchor point. Used to assist in benchmarking etc.
    attr_accessor :start_time

    #Reset the state of the fOOrth inner interpreter.
    def interpreter_reset
      @data_stack   = Array.new
      @start_time   = Time.now
    end
  end

end
