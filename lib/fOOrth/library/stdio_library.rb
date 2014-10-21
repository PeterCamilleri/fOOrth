# coding: utf-8

#* library/stdio_library.rb - The standard I/O fOOrth library.
module XfOOrth

  #===================================================
  # Some basic console I/O words.
  #===================================================

  #Print out an object.
  @object_class.create_shared_method('.', MethodWordSpec, [],
    &lambda {|vm| print self.to_s})

  #Print out a string.
  @object_class.create_shared_method('."', MethodWordSpec, [],
    &lambda {|vm| print self.to_s})

end