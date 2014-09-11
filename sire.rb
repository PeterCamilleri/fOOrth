# coding: utf-8
# A Simple Interactive Ruby Environment

require 'readline'
require 'pp'

include Readline

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

class SIRE
  #Set up the interactive session.
  def initialize
    @done    = false
    @running = false

    puts "Welcome to a Simple Interactive Ruby Environment\n"
    puts "Use command 'q' to quit.\n\n"
  end

  #Quit the interactive session.
  def q
    @done = true
    puts
    "Bye bye for now!"
  end

  #Run the interactive session.
  def run_sire
    until @done
      begin
        line = readline('SIRE>', true)
        @running = true
        result = eval line
        @running = false
        pp result unless line.length == 0

      rescue Interrupt => e
        if @running
          @running = false
          puts "\nExecution Interrupted!"
          puts "\n#{e.class} detected: #{e}\n"
          puts e.backtrace
        else
          puts "\nI'm outta here!'"
          @done = true
        end

        puts "\n"

      rescue Exception => e
        puts "\n#{e.class} detected: #{e}\n"
        puts e.backtrace
        puts
      end
    end

    puts "\n\n"
  end

end

