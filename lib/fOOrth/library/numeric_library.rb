# coding: utf-8

#* library/numeric_library.rb - Numeric support for the fOOrth library.
module XfOOrth

  #Connect the Numeric classes to the fOOrth class system.
  create_proxy(Numeric,  XfOOrth.object_class)
  create_proxy(Integer,  Numeric)
  create_proxy(Fixnum,   Integer)
  create_proxy(Bignum,   Integer)
  create_proxy(Rational, Numeric)
  create_proxy(Complex,  Numeric)

end
