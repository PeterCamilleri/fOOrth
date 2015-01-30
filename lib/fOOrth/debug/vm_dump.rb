# coding: utf-8

#* debug/vm_dump.rb - Debug support for the virtual machine.
module XfOOrth

  #* debug/vm_dump.rb - Debug support for the virtual machine.
  class VirtualMachine

    #Dump the virtual machine to the console for debug.
    def debug_dump
      source = @parser.source
      puts "\n#{self.foorth_name}"                +
           "\n  Ruby    = #{self.to_s}"           +
           "\n  Stack   = #{@data_stack.inspect}" +
           "\n  Nesting = #{@context.depth}"      +
           "\n  Quotes  = #{@quotes}"             +
           "\n  Debug   = #{@debug}"              +
           "\n  Show    = #{@show_stack}"         +
           "\n  Force   = #{@force}"              +
           "\n  Start   = #{@start_time}"         +
           "\n  Source  = #{source.source_name}"  +
           "\n  Buffer  = #{source.read_buffer.inspect}"
    end

  end

end
