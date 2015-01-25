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

  # ["file_name" OutStream] .create [an_outstream]
  out_stream.create_exclusive_method('.create', TosSpec, [], &lambda {|vm|
    file_name = vm.pop.to_s
    vm.push(XfOOrth_OutStream.new(file_name, 'w'))
  })

  # [an_outstream] .close []
  out_stream.create_shared_method('.close', TosSpec, [], &lambda {|vm|
    file.close
  })



  #[obj an_outstream] . []; print out the object as a string to the OutStream instance.
  out_stream.create_shared_method('.', TosSpec, [],
    &lambda {|vm| file << vm.pop})

  #[an_outstream] f"a string" []; print out the string to the OutStream instance.
  VirtualMachine.create_shared_method('f"', VmSpec, [], &lambda {|vm|
    out_stream, str = vm.popm(2)
    out_stream.file << str
  })

  #[obj an_outstream] .emit []; print out a character to the OutStream.
  out_stream.create_shared_method('.emit', TosSpec, [],
    &lambda {|vm| file << vm.pop.to_foorth_c})

  #[an_outstream] .cr []; print out a newline to the OutStream instance.
  out_stream.create_shared_method('.cr', TosSpec, [],
    &lambda {|vm| file << "\n"})


end
