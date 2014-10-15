# coding: utf-8
# A Simple Interactive Ruby Environment

require 'readline'
require 'pp'



class Object
  #Generate the class lineage of the object.
  def classes
    begin
      klass = self

      begin
        klass = klass.class unless klass.instance_of?(Class)
        print klass
        klass = klass.superclass
        print " < " if klass
      end while klass

      puts
    end
  end
end

module Foobar
  def hello
    puts 'Hello!'
    self
  end

  Fixnum.send(:include, self)
end

module Bluebar
  def ahoy
    puts 'Ahoy!'
    self
  end

  Fixnum.extend(self)
end

class SIRE
  #Set up the interactive session.
  def initialize
    @_done    = false
    @running = false

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
      exec_line(Readline.readline('SIRE>', true))
    end

    puts "\n\n"
  end

end

