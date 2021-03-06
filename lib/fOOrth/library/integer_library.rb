# coding: utf-8

#* library/numeric_library.rb - Numeric support for the fOOrth library.
module XfOOrth

  #Connect the Numeric classes to the fOOrth class system.
  Integer.create_foorth_proxy
  Fixnum.create_foorth_proxy
  Bignum.create_foorth_proxy

  # [a] .to_i [Integer or nil]
  Object.create_shared_method('.to_i', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Integer(self))
    rescue
      vm.push(nil)
    end
  })

  # [a] .to_i! [Integer]
  Object.create_shared_method('.to_i!', TosSpec, [],
    &lambda {|vm| vm.push(Integer.foorth_coerce(self)); })

  # [a b] .gcd [gcd(a,b)]
  Integer.create_shared_method('.gcd', TosSpec, [],
    &lambda {|vm| vm.poke(self.gcd(Integer.foorth_coerce(vm.peek)))})

  # [a b] .lcm [lcm(a,b)]
  Integer.create_shared_method('.lcm', TosSpec, [],
    &lambda {|vm| vm.poke(self.lcm(Integer.foorth_coerce(vm.peek)))})

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
  Integer.create_shared_method('and', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self & Integer.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [b,a] or [b|a]
  Integer.create_shared_method('or', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self | Integer.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [b,a] xor [b^a]
  Integer.create_shared_method('xor', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self ^ Integer.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [a] com [~a]
  Integer.create_shared_method('com', TosSpec, [],
    &lambda {|vm| vm.push(~(self)); })

  # [b,a] << [b<<a]
  Integer.create_shared_method('<<', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self << Integer.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [b,a] >> [b>>a]
  Integer.create_shared_method('>>', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self >> Integer.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })


end
