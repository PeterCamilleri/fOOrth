# coding: utf-8

#* debug/vm_dump.rb - Debug support for the virtual machine.
module XfOOrth

  #Debug support for the virtual machine.
  class VirtualMachine

    #Dump the virtual machine to the console for debug.
    def debug_dump
      puts "\n#{self.foorth_name}"
      puts "  Ruby    = #{self.to_s}"
      puts "  Stack   = #{@data_stack.inspect}"
      puts "  Nesting = #{@context.depth}"
      puts "  Quotes  = #{@quotes}"
      puts "  Debug   = #{@debug}"
      puts "  Show    = #{@show_stack}"
      puts "  Force   = #{@force}"
      puts "  Start   = #{@start_time}"
      puts "  Source  = #{@parser.source.source_name}"
      puts "  Buffer  = #{@parser.source.read_buffer.inspect}"
    end

  end

end
