require_relative 'source'

#* file_source.rb - Uses a file as a source of fOOrth source code.
module XfOOrth

  #The FileSource class used to extract fOOrth source code
  #from a string.
  class FileSource < AbstractSource

    #Initialize from a file name.
    #<br>Parameters:
    #* name - The name of the file with the fOOrth source code.
    def initialize(name)
      @file      = File.new(name, "r")
      @read_step = @file.each_line
      super()
    end

    #Close the file
    def close
      @file.close
      super()
    end

  end

end
