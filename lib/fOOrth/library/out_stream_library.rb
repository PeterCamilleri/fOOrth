# coding: utf-8

#* library/in_stream_library.rb - The fOOrth InStream class library.
module XfOOrth

  out_stream = Object.create_foorth_subclass('OutStream').new_class

  #* The fOOrth InStream file input mini-class.
  class XfOOrth_OutStream

    #The file used to perform the actual input operations.
    attr_reader :file

    #Set up the OutStream for the given file name.
    #<br>Parameters
    #* file_name - The name of the file.
    #* file_mode - The mode to use opening the file. Either 'w' or 'a'
    def initialize(file_name, file_mode)
      @file = File.new(file_name, file_mode)
    rescue
      error "Unable to open the file #{file_name} for writing."
    end

  end

  #The .new method is stubbed out.
  out_stream.create_exclusive_method('.new', TosSpec, [:stub])

  # ["file_name", OutStream] .create [an_outstream]
  out_stream.create_exclusive_method('.create', TosSpec, [], &lambda {|vm|
    file_name = vm.pop.to_s
    vm.push(XfOOrth_OutStream.new(file_name, 'w'))
  })

  # [an_outstream] .close []
  out_stream.create_shared_method('.close', TosSpec, [], &lambda {|vm|
    file.close
  })



  #[obj] . []; print out the object as a string to the OutStream instance.
  out_stream.create_shared_method('.', TosSpec, [],
    &lambda {|vm| file << vm.pop})


end