# coding: utf-8

require 'getoptlong'

#* main.rb - The entry point for a stand-alone fOOrth session.
module XfOOrth

  class VirtualMachine
    @library_loaded = false

    #Has the fOOrth run time library been loaded?
    def library_loaded?
      @library_loaded
    end

    #The fOOrth run time library has been loaded!
    def library_loaded
      @library_loaded = true
    end

    #The starting point for an interactive fOOrth programming session.
    #This method only returns when the session is closed.
    #<br>To launch a fOOrth session, simply use:
    # XfOOrth::VirtualMachine.new.main
    def main

    end

    #Process the command line arguments. A string is returned containing
    #fOOrth commands to be executed after the dictionary is loaded.
    #<br>Returns
    #A string of fOOrth commands to be executed after the dictionary is loaded.
    def process_command_line_options

    end

  end

end