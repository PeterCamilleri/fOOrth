# coding: utf-8

#* library/complex_library.rb - Numeric support for the fOOrth library.
module XfOOrth

  #Connect the Rational class to the fOOrth class system.
  Rational.create_foorth_proxy

  # Some conversion words.
  # [n d] rational [n/d]
  VirtualMachine.create_shared_method('rational', VmSpec, [],
    &lambda {|vm| n,d = popm(2); push(Rational(n,d)); })

  Rational.create_shared_method('.split', TosSpec, [],
    &lambda {|vm| vm.push(self.numerator); vm.push(self.denominator); })

  # [a] .to_r [n/d]
  Object.create_shared_method('.to_r', TosSpec, [],
    &lambda {|vm| vm.push(self.to_r); })

end