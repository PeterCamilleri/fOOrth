require_relative 'read_point'
require 'readline' #It sucks, but it will do for now.

#* console.rb - The fOOrth console support file.
module XfOOrth

  #The console class enables the use of the command line console as a source
  #for fOOrth commands and source code. The readline facility is used to enable
  #editing and command history and retrieval.
  class Console
    include Readline
    include ReadPoint

    #Initialize a new console command source.
    def initialize
      reset_read_point
    end

    #Consoles don;t really close, they just fake it.
    def close
      reset_read_point
    end

    #Get the next character of command text from the user.
    #<br>Returns
    #* The next character of user input as a string.
    def get
      read { puts; readline(prompt, true).rstrip }
    end

    #Has the scanning of the text reached the end of input?
    #<br>Returns
    #* Always returns false.
    def eof?
      false
    end

    #Build the command prompt for the user based on the state
    #of the virtual machine.
    #<br>Returns
    #* A prompt string.
    #<br> Endemic Code Smells
    # :reek:UtilityFunction
    # :reek:FeatureEnvy
    def prompt
      vm = XfOOrth.virtual_machine
      '>' * vm.level + '"' * vm.quotes
    end
  end
end
