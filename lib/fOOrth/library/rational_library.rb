# coding: utf-8

#* library/rational_library.rb - Numeric support for the fOOrth library.
module XfOOrth

  #Connect the Rational class to the fOOrth class system.
  Rational.create_foorth_proxy

  # Some conversion words.
  # [n d] rational [n/d]
  VirtualMachine.create_shared_method('rational', VmSpec, [], &lambda {|vm|
    num,den = popm(2)

    begin
      push(Rational(num.to_foorth_r, den.to_foorth_r))
    rescue
      push(nil)
    end
  })

  # Some conversion words.
  # [n d] rational! [n/d]
  VirtualMachine.create_shared_method('rational!', VmSpec, [], &lambda {|vm|
    num,den = popm(2)

    begin
      push(Rational(num.to_foorth_r, den.to_foorth_r))
    rescue
      error "F40: Cannot coerce a #{num.foorth_name}, #{den.foorth_name} to a Rational"
    end
  })

  # [err_limit float] .rationalize_to [rational]
  Numeric.create_shared_method('.rationalize_to', TosSpec, [], &lambda {|vm|
    err_limit = Float.foorth_coerce(vm.pop)

    vm.push(self.rationalize(err_limit))
  })

  Complex.create_shared_method('.rationalize_to', TosSpec, [:stub])

  # [rational] .split [numerator, denominator]
  Rational.create_shared_method('.split', TosSpec, [],
    &lambda {|vm| vm.push(self.numerator); vm.push(self.denominator); })

  # [a] .to_r [n/d]
  Object.create_shared_method('.to_r', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Rational(self))
    rescue
      vm.push(nil)
    end
  })

  # [a] .to_r! [n/d]
  Object.create_shared_method('.to_r!', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Rational(self))
    rescue
      error "F40: Cannot convert a #{self.foorth_name} to a Rational instance"
    end
  })

  # [a_float] .to_r [n/d]
  Float.create_shared_method('.to_r', TosSpec, [], &lambda {|vm|
    begin
      vm.push(self.rationalize)
    rescue
      vm.push(nil)
    end
  })

  # [a_float] .to_r! [n/d]
  Float.create_shared_method('.to_r!', TosSpec, [], &lambda {|vm|
    begin
      vm.push(self.rationalize)
    rescue
      error "F40: Cannot convert a #{self.foorth_name} to a Rational instance"
    end
  })

  # [n/d] .numerator [n]
  Numeric.create_shared_method('.numerator', TosSpec, [],
    &lambda {|vm| vm.push(self.numerator); })

  # [n/d] .denominator [d]
  Numeric.create_shared_method('.denominator', TosSpec, [],
    &lambda {|vm| vm.push(self.denominator); })

end