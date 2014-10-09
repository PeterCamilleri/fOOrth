# coding: utf-8

#* compiler/read_point.rb - A module used to read source code text from a buffer.
module XfOOrth

  #This module is used to facilitate the reading
  #of source code text from a buffer.
  module ReadPoint
    #Reset the read point to the initial conditions. Namely,
    #no text in the buffer and not at end of line,
    def reset_read_point
      @read_point = nil
      @eoln = false
    end

    #Read the next character of data from the source. If there
    #is nothing to read, call the block to get some more data to
    #work with.
    #<br>Parameters
    #* block - A block of code that retrieves the next line of
    #  source code to be processed.
    def read(&block)
      unless @read_point
        return nil unless (@read_buffer = block.call)
        @read_point = @read_buffer.each_char
      end

      begin
        result, @eoln = @read_point.next, false
      rescue StopIteration
        result, @read_point, @eoln = ' ', nil, true
      end

      result
    end

    #Is the read point at the end of line?
    def eoln?
      @eoln
    end
  end

end
