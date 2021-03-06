# coding: utf-8

#* library/in_stream_library.rb - The fOOrth InStream class library.
module XfOOrth

  in_stream = Object.create_foorth_subclass('InStream').new_class

  #* The fOOrth InStream file input mini-class.
  class XfOOrth_InStream

    #The file used to perform the actual input operations.
    attr_reader :file

    #Set up the InStream for the given file name.
    def initialize(file_name)
      @file = File.new(file_name, 'r')
    rescue
      error "F50: Unable to open the file #{file_name} for reading."
    end

  end

  #The .new method is stubbed out.
  in_stream.create_exclusive_method('.new', TosSpec, [:stub])

  # ["file_name", InStream] .open [an_instream]
  in_stream.create_exclusive_method('.open', TosSpec, [], &lambda {|vm|
    file_name = vm.pop.to_s.freeze
    vm.push(XfOOrth_InStream.new(file_name))
  })

  in_stream.create_exclusive_method('.open{{', NosSpec, [], &lambda {|vm|
    block = vm.pop
    file_name = vm.pop.to_s.freeze
    in_stream = XfOOrth_InStream.new(file_name)

    begin
      in_stream.instance_exec(vm, nil, nil, &block)
    ensure
      in_stream.file.close
    end
  })

  # [an_instream] .close []
  in_stream.create_shared_method('.close', TosSpec, [], &lambda {|vm|
    file.close
  })

  # [an_instream] .gets ["a_string"]
  in_stream.create_shared_method('.gets', TosSpec, [], &lambda {|vm|
    vm.push(file.gets.chomp)
  })

  #{self = an_instream} [] ~gets ["a_string"]
  in_stream.create_shared_method('~gets', SelfSpec, [], &lambda {|vm|
    vm.push(file.gets.chomp)
  })


  # [an_instream] .getc ["a_character"]
  in_stream.create_shared_method('.getc', TosSpec, [], &lambda {|vm|
    vm.push(file.getc)
  })

  #{self = an_instream} [] ~getc ["a_character"]
  in_stream.create_shared_method('~getc', SelfSpec, [], &lambda {|vm|
    vm.push(file.getc)
  })


  # [file_name InStream] .get_all [["line 1", "line 2", ... "line n"]]
  in_stream.create_exclusive_method('.get_all', TosSpec, [], &lambda {|vm|
    begin
      file_name = vm.pop.to_s.freeze
      vm.push(IO.readlines(file_name).map{|line| line.chomp })
    rescue
      error "F50: Unable to open the file #{file_name} for reading all."
    end
  })

end
