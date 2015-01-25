# coding: utf-8

#* library/in_stream_library.rb - The fOOrth InStream class library.
module XfOOrth

  out_stream = Object.create_foorth_subclass('OutStream').new_class

  #* The fOOrth InStream file input mini-class.
  class XfOOrth_OutStream

    #The file used to perform the actual input operations.
    attr_reader :file

  end

end
