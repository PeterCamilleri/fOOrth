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

  # Some stack arithmetic words.
  # [b,a] + [b+a]
  Numeric.create_shared_method('+', NosSpec, [],
    &lambda {|vm| vm.poke(self + vm.peek); })

  # [b,a] - [b-a]
  Numeric.create_shared_method('-', NosSpec, [],
    &lambda {|vm| vm.poke(self - vm.peek); })

  # [b,a] * [b*a]
  Numeric.create_shared_method('*', NosSpec, [],
    &lambda {|vm| vm.poke(self * vm.peek); })

  # [b,a] / [b/a]
  Numeric.create_shared_method('/', NosSpec, [],
    &lambda {|vm| vm.poke(self / vm.peek); })

  # [b,a] mod [b%a]
  Numeric.create_shared_method('mod', NosSpec, [],
    &lambda {|vm| vm.poke(self % vm.peek); })

  # [a] neg [-a]
  Numeric.create_shared_method('neg', TosSpec, [],
    &lambda {|vm| vm.push(-self); })

  # Some bitwise operation words.
  # [b,a] and [b&a]
  Numeric.create_shared_method('and', TosSpec, [],
    &lambda {|vm| vm.poke(self.to_i & vm.peek.to_i); })

  # [b,a] or [b|a]
  Numeric.create_shared_method('or', TosSpec, [],
    &lambda {|vm| vm.poke(self.to_i | vm.peek.to_i); })

  # [b,a] xor [b^a]
  Numeric.create_shared_method('xor', TosSpec, [],
    &lambda {|vm| vm.poke(self.to_i ^ vm.peek.to_i); })

  # [a] com [~a]
  Numeric.create_shared_method('com', TosSpec, [],
    &lambda {|vm| vm.push(~(self.to_i)); })

  # [b,a] << [b<<a]
  Numeric.create_shared_method('<<', NosSpec, [],
    &lambda {|vm| vm.poke(self.to_i << vm.peek.to_i); })

  # [b,a] >> [b>>a]
  Numeric.create_shared_method('>>', NosSpec, [],
    &lambda {|vm| vm.poke(self.to_i >> vm.peek.to_i); })

end
