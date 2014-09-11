# coding: utf-8

require 'getoptlong'

#* main.rb - The entry point for a stand-alone fOOrth session.
module XfOOrth

  #Has the library been loaded?
  @library_loaded = false

  #Has the fOOrth run time library been loaded?
  def self.library_loaded?
    @library_loaded
  end

  #The fOOrth run time library has been loaded!
  def self.library_loaded
    @library_loaded = true
  end

  #The starting point for an interactive fOOrth programming session.
  #This method only returns when the session is closed.
  #<br>Returns:
  #* The virtual machine used to run the session.
  #<br>To launch a fOOrth interactive session, simply use:
  # XfOOrth::main
  #<br>Endemic Code Smells
  # :reek:TooManyStatements
  def self.main
    vm = VirtualMachine.new('main')

    begin

      loop do
        begin
          running ||= start_up(vm)
          vm.eceute_console

        rescue ForceAbort => forced_abort
          vm.display_abort(forced_abort)
          break unless running
        end
      end

    rescue Interrupt
      puts "\nProgram interrupted. Exiting fOOrth."

    rescue ForceExit
      puts "\nQuit command received. Exiting fOOrth."

    rescue SilentExit
      puts

    rescue Exception => err
      puts "\n#{err.class.to_s.gsub(/.*::/, '')} detected: #{err}"
      puts err.backtrace

    end

    vm
  end

  #Perform one time start-up actions.
  def self.start_up(vm)
    announcement
    vm.debug = false
    vm.exec_str.process_command_line_options
    true
  end

  #Display the start-up messages for the interactive session.
  def self.announcement
    puts "fOOrth Reference Implementation Version: #{XfOOrth.version}"
    fmt = '%Y-%m-%d at %I:%M%P'
    puts "Session began on date: #{Time.now.strftime(fmt)}"
  end

  #Process the command line arguments. A string is returned containing
  #fOOrth commands to be executed after the dictionary is loaded.
  #<br>Returns
  #* A string of fOOrth commands to be executed after the dictionary is loaded.
  #<br>Endemic Code Smells
  # :reek:TooManyStatements
  def self.process_command_line_options
    begin
      defer, found = "", false

      opts = GetoptLong.new(
        [ "--help",  "-h", "-?", GetoptLong::NO_ARGUMENT ],
        [ "--load",  "-l",       GetoptLong::REQUIRED_ARGUMENT ],
        [ "--debug", "-d",       GetoptLong::NO_ARGUMENT ],
        [ "--quit",  "-q",       GetoptLong::NO_ARGUMENT ],
        [ "--words", "-w",       GetoptLong::NO_ARGUMENT ])

      # Translate the parsed options into fOOrth.
      opts.each do |opt, arg|
        unless found
          puts; found = true
        end

        case opt
        when "--debug"
          @debug = true
        when "--load"
          defer << "load\"#{arg}\" "
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
      puts "--words -w              List the current vocabulary."
      puts
      raise SilentExit
    end

    defer
  end

end