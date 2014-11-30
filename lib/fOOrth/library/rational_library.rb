# coding: utf-8

#* library/rational_library.rb - Numeric support for the fOOrth library.
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

  # [n/d] .numerator [n]
  Numeric.create_shared_method('.numerator', TosSpec, [],
    &lambda {|vm| vm.push(self.numerator); })

  # [n/d] .denominator [d]
  Numeric.create_shared_method('.denominator', TosSpec, [],
    &lambda {|vm| vm.push(self.denominator); })

end