# coding: utf-8

require_relative 'source/read_point'

#* compiler/source.rb - The abstract source class shared by many code sources.
module XfOOrth

  #The Source class used to contain code common to most sources.
  class AbstractSource
    include ReadPoint

    #Initialize the abstract base class.
    def initialize
      reset_read_point
      @eof = false
      @peek_buffer = nil
    end

    #Close the source.
    def close
      @eoln = true
      @eof = true
      @peek_buffer = nil
    end

    #Get the next character of input data
    #<br>Returns:
    #* The next character or nil if none are available.
    def get
      return nil if (@eof && !@peek_buffer)

      @peek_buffer || read do
        begin
          @read_step.next.rstrip
        rescue StopIteration
          @eof = true
          nil
        end
      end
    ensure
      @peek_buffer = nil
    end

    #Peek ahead by one character.
    #<br>Returns:
    #* A peek at next character or nil if none are available.
    def peek
      @peek_buffer ||= get unless eoln?
    end

    #Has the source reached the end of the available data?
    #<br>Returns:
    #* True if the end is reached else false.
    def eof?
      @eof
    end
  end
end

require_relative 'source/string_source'
require_relative 'source/file_source'
require_relative 'source/console'
