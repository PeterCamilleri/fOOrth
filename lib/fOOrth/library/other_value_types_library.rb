# coding: utf-8

#* library/other_value_types_library.rb - Support for true, false, and nil in
#  the fOOrth library.
module XfOOrth

  #Connect the TrueClass class to the fOOrth class system.
  create_proxy(TrueClass, XfOOrth.object_class)

  #Connect the FalseClass class to the fOOrth class system.
  create_proxy(FalseClass, XfOOrth.object_class)

  #Connect the NilClass class to the fOOrth class system.
  create_proxy(NilClass, XfOOrth.object_class)

end
