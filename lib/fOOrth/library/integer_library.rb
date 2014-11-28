# coding: utf-8

#* library/numeric_library.rb - Numeric support for the fOOrth library.
module XfOOrth

  #Connect the Numeric classes to the fOOrth class system.
  Integer.create_foorth_proxy
  Fixnum.create_foorth_proxy
  Bignum.create_foorth_proxy

  # [a b] .gcd [gcd(a,b)]
  Integer.create_shared_method('.gcd', TosSpec, [],
    &lambda {|vm| vm.poke(self.gcd(vm.peek)); })

  # [a b] .lcm [lcm(a,b)]
  Integer.create_shared_method('.lcm', TosSpec, [],
    &lambda {|vm| vm.poke(self.lcm(vm.peek)); })

end
