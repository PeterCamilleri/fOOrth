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
      error "F51: Unable to open the file #{file_name} for writing."
    end

  end

  #The .new method is stubbed out.
  out_stream.create_exclusive_method('.new', TosSpec, [:stub])

  # ["file_name" OutStream] .create [an_outstream]
  out_stream.create_exclusive_method('.create', TosSpec, [], &lambda {|vm|
    file_name = vm.pop.to_s
    vm.push(XfOOrth_OutStream.new(file_name, 'w'))
  })

  # ["file_name" OutStream] .create{{ ... }} []
  out_stream.create_exclusive_method('.create{{', TosSpec, [], &lambda {|vm|
    block = vm.pop
    file_name = vm.pop.to_s
    out_stream = XfOOrth_OutStream.new(file_name, 'w')

    begin
      out_stream.instance_exec(vm, nil, nil, &block)
    ensure
      out_stream.file.close
    end
  })

  # ["file_name" OutStream] .append{{ ... }} []
  out_stream.create_exclusive_method('.append{{', TosSpec, [], &lambda {|vm|
    block = vm.pop
    file_name = vm.pop.to_s
    out_stream = XfOOrth_OutStream.new(file_name, 'a')

    begin
      out_stream.instance_exec(vm, nil, nil, &block)
    ensure
      out_stream.file.close
    end
  })

  # ["file_name" OutStream] .append [an_outstream]
  out_stream.create_exclusive_method('.append', TosSpec, [], &lambda {|vm|
    file_name = vm.pop.to_s
    vm.push(XfOOrth_OutStream.new(file_name, 'a'))
  })

  # [an_outstream] .close []
  out_stream.create_shared_method('.close', TosSpec, [], &lambda {|vm|
    file.close
  })

  #[obj an_outstream] . []; print out the object as a string to the OutStream instance.
  out_stream.create_shared_method('.', TosSpec, [],
    &lambda {|vm| file << vm.pop})

  #{self = an_outstream} [obj] ~ []; print out the object as a string to the OutStream self.
  out_stream.create_shared_method('~', SelfSpec, [],
    &lambda {|vm| file << vm.pop})

  #{self = an_outstream} [] ~"a string" []; print out the string to the OutStream self.
  out_stream.create_shared_method('~"', SelfSpec, [],
    &lambda {|vm| file << vm.pop })


  #[obj an_outstream] .emit []; print out a character to the OutStream.
  out_stream.create_shared_method('.emit', TosSpec, [],
    &lambda {|vm| file << vm.pop.to_foorth_c})

  #{self = an_outstream} [obj] ~emit []; print out a character to the OutStream self.
  out_stream.create_shared_method('~emit', SelfSpec, [],
    &lambda {|vm| file << vm.pop.to_foorth_c})


  #[an_outstream] .cr []; print out a newline to the OutStream instance.
  out_stream.create_shared_method('.cr', TosSpec, [],
    &lambda {|vm| file << "\n"})

  #{self = an_outstream} [] ~cr []; print out a newline to the OutStream self.
  out_stream.create_shared_method('~cr', SelfSpec, [],
    &lambda {|vm| file << "\n"})


  #[an_outstream] .space []; print out a space to the OutStream instance.
  out_stream.create_shared_method('.space', TosSpec, [],
    &lambda {|vm| file << " "})

  #{self = an_outstream} [] ~space []; print out a space to the OutStream self.
  out_stream.create_shared_method('~space', SelfSpec, [],
    &lambda {|vm| file << " "})


  #[count an_outstream] .spaces []; print out spaces to the OutStream instance.
  out_stream.create_shared_method('.spaces', TosSpec, [],
    &lambda {|vm| file << " " * Integer.foorth_coerce(vm.pop())})

  #{self = an_outstream} [count] ~spaces []; print out spaces to the OutStream self.
  out_stream.create_shared_method('~spaces', SelfSpec, [],
    &lambda {|vm| file << " " * Integer.foorth_coerce(vm.pop())})

  # [text_array "file_name" OutStream] .put_all []; Write the array to file_name
  out_stream.create_exclusive_method('.put_all', TosSpec, [], &lambda {|vm|
    file_name = vm.pop.to_s
    file_source = vm.pop
    out_stream = XfOOrth_OutStream.new(file_name, 'w')

    begin
      file_source.each {|line| out_stream.file.puts(line) }
    ensure
      out_stream.file.close
    end
  })

  # [text_array "file_name" OutStream] .append_all []; Append the array to file_name
  out_stream.create_exclusive_method('.append_all', TosSpec, [], &lambda {|vm|
    file_name = vm.pop.to_s
    file_source = vm.pop
    out_stream = XfOOrth_OutStream.new(file_name, 'a')

    begin
      file_source.each {|line| out_stream.file.puts(line) }
    ensure
      out_stream.file.close
    end
  })

end
