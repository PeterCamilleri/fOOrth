# coding: utf-8

#* library/class_library.rb - The fOOrth Class class library.
module XfOOrth

  in_stream = Object.create_foorth_subclass('InStream').new_class

  class XfOOrth_InStream
    attr_reader :file

    def initialize(file_name)
      @file = File.new(file_name, 'r')
    rescue
      error "Unable to open the file #{file_name} for reading."
    end
  end

  # ["file_name", InStream] .open [an_instream]
  in_stream.create_exclusive_method('.open', TosSpec, [], &lambda {|vm|
    file_name = vm.pop.to_s
    vm.push(XfOOrth_InStream.new(file_name))
  })

  # [an_instream] .close []
  in_stream.create_shared_method('.close', TosSpec, [], &lambda {|vm|
    file.close
  })

  # [an_instream] .gets ["a_string"]
  in_stream.create_shared_method('.gets', TosSpec, [], &lambda {|vm|
    vm.push(file.gets.chomp)
  })


end
