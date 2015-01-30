# coding: utf-8

#* debug/display_abort.rb - Display diagnostic information on an error.
module XfOOrth

  #* debug/display_abort.rb - Display diagnostic information on an error.
  class VirtualMachine

    #Display the diagnostic data required for a language abort error.
    #<br>Parameters:
    #* exception - The exception object that required the system abort or a
    #  string describing the error that was encountered.
    def display_abort(exception)
      puts "\n#{exception}"

      if debug
        puts "Data Stack Contents: #{data_stack.inspect}"

        if @context
          @context.debug_dump(self)
        else
          puts "Error: No context is available!"
        end

        puts
      end

      interpreter_reset
      compiler_reset
    end

  end

end

