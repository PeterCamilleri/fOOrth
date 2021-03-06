# coding: utf-8

require 'getoptlong'

#* main.rb - The entry point for a stand-alone foorth session.
module XfOOrth

  #The user facing format used for date/time display.
  TimeFormat = '%Y-%m-%d at %I:%M%P'

  #The starting point for an interactive fOOrth programming session.
  #This method only returns when the session is closed.
  #<br>Returns:
  #* The virtual machine used to run the session.
  #<br>To launch a fOOrth interactive session, simply use:
  # XfOOrth::main
  #<br>Endemic Code Smells
  #* :reek:TooManyStatements
  def self.main
    vm = VirtualMachine.vm('Console')
    running = false

    loop do
      begin
        running ||= start_up(vm)
        vm.process_console

      rescue Interrupt, ForceExit, SilentExit, MiniReadlineEOI => err
        puts "\n#{err.foorth_message}"
        break

      rescue StandardError => err
        vm.display_abort(err)

      rescue Exception => err
        puts "\n#{err.class.to_s.gsub(/.*::/, '')} detected: #{err}"
        puts err.backtrace
        break
      end

      break unless running
    end

    vm
  end

  #Perform one time start-up actions.
  def self.start_up(vm)
    announcements
    vm.debug = false
    vm.show_stack = false
    vm.process_string(process_command_line_options)
    true
  end

  #Display the start-up messages for the interactive session.
  def self.announcements
    puts "Welcome to fOOrth: fO(bject)O(riented)rth."
    puts "\nfOOrth Reference Implementation Version: #{XfOOrth.version}"
    puts "\nSession began on: #{Time.now.strftime(TimeFormat)}"
  end

  #Process the command line arguments. A string is returned containing
  #fOOrth commands to be executed after the dictionary is loaded.
  #<br>Returns
  #* A string of fOOrth commands to be executed after the dictionary is loaded.
  #<br>Endemic Code Smells
  #* :reek:TooManyStatements
  def self.process_command_line_options
    begin

      defer, found = "", false

      opts = GetoptLong.new(
        [ "--help",  "-h", "-?", GetoptLong::NO_ARGUMENT ],
        [ "--load",  "-l",       GetoptLong::REQUIRED_ARGUMENT ],
        [ "--debug", "-d",       GetoptLong::NO_ARGUMENT ],
        [ "--show",  "-s",       GetoptLong::NO_ARGUMENT ],
        [ "--quit",  "-q",       GetoptLong::NO_ARGUMENT ],
        [ "--words", "-w",       GetoptLong::NO_ARGUMENT ])

      # Translate the parsed options into fOOrth.
      opts.each do |opt, arg|

        unless found
          puts
          found = true
        end

        case opt
        when "--debug"
          defer << ")debug "
        when "--show"
          defer << ")show "
        when "--load"
          defer << ")load#{arg.inspect}"
        when "--quit"
          defer << ")quit "
        when "--words"
          defer << ")words "
        else
          fail SilentExit
        end
      end

      puts if found

    rescue Exception
      puts
      puts "fOOrth available options:"
      puts
      puts "--help  -h  -?          Display this message and exit."
      puts "--load  -l <filename>   Load the specified fOOrth source file."
      puts "--debug -d              Default to debug ON."
      puts "--quit  -q              Quit after processing the command line."
      puts "--show  -s              Default to show results ON."
      puts "--words -w              List the current vocabulary."
      puts
      raise SilentExit
    end

    defer
  end

end