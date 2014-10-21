# coding: utf-8

#* library/numeric_library.rb - Numeric support for the fOOrth library.
module XfOOrth

  #Connect the Numeric class to the fOOrth class system.
  create_proxy(Numeric, XfOOrth.object_class)

end
