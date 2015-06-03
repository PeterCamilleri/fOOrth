# coding: utf-8

#* library/rational_library.rb - Numeric support for the fOOrth library.
module XfOOrth

  #Connect the Rational class to the fOOrth class system.
  Rational.create_foorth_proxy

  # Some conversion words.
  # [n d] rational [n/d]
  VirtualMachine.create_shared_method('rational', VmSpec, [], &lambda {|vm|
    num,den = popm(2)

    num = begin
            num.rationalize
          rescue
            num
          end

    den = begin
            den.rationalize
          rescue
            den
          end

    begin
      push(Rational(num,den))
    rescue
      error "F40: Cannot coerce a #{num.foorth_name}, #{den.foorth_name} to a Rational"
    end
  })

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