# coding: utf-8

#* library/numeric_library.rb - Numeric support for the fOOrth library.
module XfOOrth

  #Connect the Numeric classes to the fOOrth class system.
  Integer.create_foorth_proxy
  Fixnum.create_foorth_proxy
  Bignum.create_foorth_proxy

  # [a] .to_i [Integer]
  Object.create_shared_method('.to_i', TosSpec, [],
    &lambda {|vm| vm.push(Integer.foorth_coerce(self)); })

  # [a b] .gcd [gcd(a,b)]
  Integer.create_shared_method('.gcd', TosSpec, [],
    &lambda {|vm| vm.poke(self.gcd(vm.peek))})

  # [a b] .lcm [lcm(a,b)]
  Integer.create_shared_method('.lcm', TosSpec, [],
    &lambda {|vm| vm.poke(self.lcm(vm.peek))})

  # [a] .even? [flag]
  Integer.create_shared_method('.even?', TosSpec, [],
    &lambda {|vm| vm.push(self.even?)})

  # [a] .odd? [flag]
  Integer.create_shared_method('.odd?', TosSpec, [],
    &lambda {|vm| vm.push(self.odd?)})

  # [a] 2* [|a|]
  Integer.create_shared_method('2*', TosSpec, [],
    &lambda {|vm| vm.push(self << 1); })

  # [a] 2/ [|a|]
  Integer.create_shared_method('2/', TosSpec, [],
    &lambda {|vm| vm.push(self >> 1); })

  # Some bitwise operation words.
  # [b,a] and [b&a]
  Integer.create_shared_method('and', NosSpec, [],
    &lambda {|vm| vm.poke(self & Integer.foorth_coerce(vm.peek)); })

  # [b,a] or [b|a]
  Integer.create_shared_method('or', NosSpec, [],
    &lambda {|vm| vm.poke(self | Integer.foorth_coerce(vm.peek)); })

  # [b,a] xor [b^a]
  Integer.create_shared_method('xor', NosSpec, [],
    &lambda {|vm| vm.poke(self ^ Integer.foorth_coerce(vm.peek)); })

  # [a] com [~a]
  Integer.create_shared_method('com', TosSpec, [],
    &lambda {|vm| vm.push(~(self)); })

  # [b,a] << [b<<a]
  Integer.create_shared_method('<<', NosSpec, [],
    &lambda {|vm| vm.poke(self << Integer.foorth_coerce(vm.peek)); })

  # [b,a] >> [b>>a]
  Integer.create_shared_method('>>', NosSpec, [],
    &lambda {|vm| vm.poke(self >> Integer.foorth_coerce(vm.peek)); })


end
