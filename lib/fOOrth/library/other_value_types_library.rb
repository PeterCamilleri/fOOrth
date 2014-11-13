# coding: utf-8

#* library/other_value_types_library.rb - Support for true, false, and nil in
#  the fOOrth library.
module XfOOrth

  #Connect the TrueClass class to the fOOrth class system.
  TrueClass.create_foorth_proxy

  #Connect the FalseClass class to the fOOrth class system.
  FalseClass.create_foorth_proxy

  #Connect the NilClass class to the fOOrth class system.
  NilClass.create_foorth_proxy

end
