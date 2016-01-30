# coding: utf-8
# A Simple Interactive Ruby Environment

$no_alias_read_line_module = true
require 'mini_readline'
require 'pp'

class Object
  #Generate the class lineage of the object.
  def classes
    begin
      result = ""
      klass  = self.instance_of?(Class) ? self : self.class

      begin
        result << klass.to_s
        klass = klass.superclass
        result << " < " if klass
      end while klass

      result
    end
  end
end

class SIRE
  #Set up the interactive session.
  def initialize
    @_done = false

    puts "Welcome to a Simple Interactive Ruby Environment\n"
    puts "Use command 'q' to quit.\n\n"
  end

  #Quit the interactive session.
  def q
    @_done = true
    puts
    "Bye bye for now!"
  end

  #Load and run a file
  def l(file_name)
    @_break = false
    lines = IO.readlines(file_name)

    lines.each do |line|
      exec_line(line)
      return if @_break
    end

    "End of file '#{file_name}'."
  end

  #Execute a single line.
  def exec_line(line)
    result = eval line
    pp result unless line.length == 0

  rescue Interrupt => e
    @_break = true
    puts "\nExecution Interrupted!"
    puts "\n#{e.class} detected: #{e}\n"
    puts e.backtrace
    puts "\n"

  rescue Exception => e
    @_break = true
    puts "\n#{e.class} detected: #{e}\n"
    puts e.backtrace
    puts
  end

  #Run the interactive session.
  def run_sire
    until @_done
      @_break = false
      exec_line(MiniReadline.readline('SIRE>', true))
    end

    puts "\n\n"

  rescue Interrupt => e
    puts "\nInterrupted! Program Terminating."
  end

end

if __FILE__ == $0
  require './lib/fOOrth'
  SIRE.new.run_sire
end
