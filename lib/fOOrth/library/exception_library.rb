# coding: utf-8

#* library/exception_library.rb - The exception system of the fOOrth library.
module XfOOrth

  #Connect the Exception class to the fOOrth class system.
  StandardError.create_foorth_proxy('Exception')

end