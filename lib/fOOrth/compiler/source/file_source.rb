# coding: utf-8

#* compiler/file_source.rb - Uses a file as a source of fOOrth source code.
module XfOOrth

  #The FileSource class used to extract fOOrth source code
  #from a string.
  class FileSource < AbstractSource

    #Initialize from a file name.
    #<br>Parameters:
    #* name - The name of the file with the fOOrth source code.
    def initialize(name)
      @name      = name
      @file      = File.new(name, "r")
      @read_step = @file.each_line
      super()
    end

    #Close the file
    def close
      @file.close
      super()
    end

    #What is the source of this text?
    def source_name
      "A file: #{@name}"
    end

    #Get the name of the file
    def file_name
      @name
    end
  end

end
