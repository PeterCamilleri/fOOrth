# coding: utf-8

#* display_abort.rb - Display diagnostic information on an error.
module XfOOrth

  #* display_abort.rb - Display diagnostic information on an error.
  class VirtualMachine

    #Display the diagnostic data required for a language abort error.
    #<br>Parameters:
    #* exception - The exception object that required the system abort.
    def display_abort(exception)
      puts "\n#{exception}"

      if debug
        puts "Data Stack Contents: #{data_stack.inspect}"
      end

      unless @context
        puts "Error: No context is available!"
      end

      interpreter_reset
      compiler_reset
    end

  end

end

