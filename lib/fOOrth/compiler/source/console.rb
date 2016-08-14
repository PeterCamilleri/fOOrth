# coding: utf-8

#* compiler/console.rb - The fOOrth console support file.
module XfOOrth

  #The console class enables the use of the command line console as a source
  #for fOOrth commands and source code. The readline facility is used to enable
  #editing and command history and retrieval.
  class Console
    include ReadPoint

    #Initialize a new console command source.
    def initialize
      @peek_buffer = nil

      reset_read_point

      auto_src = lambda { SymbolMap.forward_map.keys.sort  }

      @edit = MiniReadline::Readline.new(history: true,
                                         auto_complete: true,
                                         auto_source: MiniReadline::ArraySource,
                                         array_src: auto_src,
                                         eoi_detect: true)
    end

    #Close the console source.
    def close
      @peek_buffer = nil
      reset_read_point
    end

    alias flush close

    #Get the next character of command text from the user.
    #<br>Returns
    #* The next character of user input as a string.
    def get
      @peek_buffer || read do
        @edit.readline(prompt: prompt).rstrip
      end
    ensure
      @peek_buffer = nil
    end

    #Peek ahead by one character.
    #<br>Returns:
    #* A peek at next character or nil if none are available.
    def peek
      @peek_buffer ||= get unless @eoln
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
    #* :reek:FeatureEnvy
    def prompt
      vm = Thread.current[:vm]
      puts

      if vm.show_stack
        vm.data_stack.to_foorth_s(vm)
        puts vm.pop
      end

      '>' * vm.context.depth + '"' * vm.quotes + '(' * vm.parens
    end

    #What is the source of this text?
    def source_name
      "The console."
    end

    #The console has no file name to return.
    def fine_name
      nil
    end

  end
end
