# coding: utf-8

#* debug/display_abort.rb - Display diagnostic information on an error.
module XfOOrth

  #* debug/display_abort.rb - Display diagnostic information on an error.
  #<br>Endemic Code Smells
  #* :reek:TooManyStatements
  class VirtualMachine

    #Display the diagnostic data required for a language abort error.
    #<br>Parameters:
    #* exception - The exception object that required the system abort or a
    #  string describing the error that was encountered.
    def display_abort(exception)
      puts "\n#{exception.foorth_message}"

      if debug
        puts "Data Stack Contents: #{data_stack.inspect}"

        if @context
          @context.debug_dump(self)
        else
          puts "Error: No context is available!"
        end

        puts "\nInternal Backtrace Dump:"
        puts
        puts exception.backtrace
        puts
      end

      reset
    end

  end

end

