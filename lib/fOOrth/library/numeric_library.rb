# coding: utf-8

#* library/numeric_library.rb - Numeric support for the fOOrth library.
module XfOOrth

  #Connect the Numeric classes to the fOOrth class system.
  Numeric.create_foorth_proxy
  Integer.create_foorth_proxy
  Fixnum.create_foorth_proxy
  Bignum.create_foorth_proxy
  Rational.create_foorth_proxy
  Complex.create_foorth_proxy

end
