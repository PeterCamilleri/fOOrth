# coding: utf-8

#* This meaningless entry exists to shut up rdoc!
module Math #:nodoc: don't document this
end

#* library/numeric_library.rb - Numeric support for the fOOrth library.
module XfOOrth

  #Connect the Numeric classes to the fOOrth class system.
  Numeric.create_foorth_proxy
  Float.create_foorth_proxy

  # Some conversion words.
  # [a] .to_n [Number or nil]
  Object.create_shared_method('.to_n', TosSpec, [],
    &lambda {|vm| vm.push(self.to_foorth_n); })

  # Some conversion words.
  # [a] .to_n! [Number]
  Object.create_shared_method('.to_n!', TosSpec, [], &lambda {|vm|
    if (result = self.to_foorth_n)
      vm.push(result);
    else
      error "F40: Cannot convert a #{self.foorth_name} to a Numeric instance"
    end
  })

  # [a] .to_f [Float or nil]
  Object.create_shared_method('.to_f', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Float(self))
    rescue
      vm.push(nil)
    end
  })

  # [num_digits a_number] .round_to [a_float]
  Numeric.create_shared_method('.round_to', TosSpec, [], &lambda {|vm|
    value = Float.foorth_coerce(self)
    digits = Integer.foorth_coerce(vm.pop)
    vm.push(value.round(digits))
  })

  # [a] .to_f! [Float]
  Object.create_shared_method('.to_f!', TosSpec, [],
    &lambda {|vm| vm.push(Float.foorth_coerce(self)) })

  # Some comparison words.
  # [b,a] > if b > a then [true] else [false]
  Numeric.create_shared_method('>', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self > self.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [b,a] < if b < a then [true] else [false]
  Numeric.create_shared_method('<', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self < self.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [b,a] >= if b >= a then [true] else [false]
  Numeric.create_shared_method('>=', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self >= self.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [b,a] <= if b <= a then [true] else [false]
  Numeric.create_shared_method('<=', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self <= self.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [b,a] <=> if b <=> a then [true] else [false]
  Numeric.create_shared_method('<=>', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self <=> self.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # Some comparison with zero words.
  # [b,a] 0= if b == 0 then [true] else [false]
  Numeric.create_shared_method('0=', TosSpec, [],
    &lambda {|vm| vm.push(self == 0); })

  # [b,a] 0<> if b != 0 then [true] else [false]
  Numeric.create_shared_method('0<>', TosSpec, [],
    &lambda {|vm| vm.push(self != 0); })

  # [b,a] 0> if b > 0 then [true] else [false]
  Numeric.create_shared_method('0>', TosSpec, [],
    &lambda {|vm| vm.push(self > 0); })

  # [b,a] 0< if b < 0 then [true] else [false]
  Numeric.create_shared_method('0<', TosSpec, [],
    &lambda {|vm| vm.push(self < 0); })

  # [b,a] 0>= if b >= 0 then [true] else [false]
  Numeric.create_shared_method('0>=', TosSpec, [],
    &lambda {|vm| vm.push(self >= 0); })

  # [b,a] 0<= if b <= 0 then [true] else [false]
  Numeric.create_shared_method('0<=', TosSpec, [],
    &lambda {|vm| vm.push(self <= 0); })

  # [b] 0<=> b < 0 [-1], b = 0 [0], b > 0 [1]
  Numeric.create_shared_method('0<=>', TosSpec, [],
    &lambda {|vm| vm.push(self <=> 0); })

  # Some stack arithmetic words.
  # [b,a] + [b+a]
  Numeric.create_shared_method('+', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self + self.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [b,a] - [b-a]
  Numeric.create_shared_method('-', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self - self.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [b,a] * [b*a]
  Numeric.create_shared_method('*', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self * self.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [b,a] ** [b**a]
  Numeric.create_shared_method('**', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self ** Float.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [b,a] / [b/a]
  Numeric.create_shared_method('/', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self / self.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [b,a] mod [b%a]
  Numeric.create_shared_method('mod', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self % self.foorth_coerce(vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [a] neg [-a]
  Numeric.create_shared_method('neg', TosSpec, [],
    &lambda {|vm| vm.push(-self); })

  # [a] .1/x [-a]
  Numeric.create_shared_method('.1/x', TosSpec, [],
    &lambda {|vm| vm.push(1/self); })

  # [a] .abs [|a|]
  Numeric.create_shared_method('.abs', TosSpec, [],
    &lambda {|vm| vm.push(self.abs); })

  # [a] 1+ [a+1]
  Numeric.create_shared_method('1+', TosSpec, [],
    &lambda {|vm| vm.push(self+1); })

  # [a] 1- [a-1]
  Numeric.create_shared_method('1-', TosSpec, [],
    &lambda {|vm| vm.push(self-1); })

  # [a] 2+ [a+2]
  Numeric.create_shared_method('2+', TosSpec, [],
    &lambda {|vm| vm.push(self+2); })

  # [a] 2- [a-2]
  Numeric.create_shared_method('2-', TosSpec, [],
    &lambda {|vm| vm.push(self-2); })

  # [a] 2* [a*2]
  Numeric.create_shared_method('2*', TosSpec, [],
    &lambda {|vm| vm.push(self*2); })

  # [a] 2/ [a/2]
  Numeric.create_shared_method('2/', TosSpec, [],
    &lambda {|vm| vm.push(self/2); })

  # [a] .ceil [a']; where a' is the closest integer >= a
  Numeric.create_shared_method('.ceil', TosSpec, [],
    &lambda {|vm| vm.push(self.ceil); })

  # [a] .floor [a']; where a' is the closest integer <= a
  Numeric.create_shared_method('.floor', TosSpec, [],
    &lambda {|vm| vm.push(self.floor); })

  # [a] .round [a']; where a' is the integer closest to a
  Numeric.create_shared_method('.round', TosSpec, [],
    &lambda {|vm| vm.push(self.round); })


  #Advanced math stuff!
  # [] pi [3.141592653589793]
  VirtualMachine.create_shared_method('pi', MacroSpec, [:macro, "vm.push(Math::PI)"])

  # [] e [2.718281828459045]
  VirtualMachine.create_shared_method('e', MacroSpec, [:macro, "vm.push(Math::E)"])

  #The number of degrees in one radian.
  DegreesPerRadian = 180.0/Math::PI

  # [] dpr [2.718281828459045]
  VirtualMachine.create_shared_method('dpr', MacroSpec,
    [:macro, "vm.push(DegreesPerRadian)"])

  # [degrees] .d2r [radians]
  Numeric.create_shared_method('.d2r', TosSpec, [],
    &lambda {|vm| vm.push(Float.foorth_coerce(self)/DegreesPerRadian); })

  # [radians] .r2d [degrees]
  Numeric.create_shared_method('.r2d', TosSpec, [],
    &lambda {|vm| vm.push(Float.foorth_coerce(self)*DegreesPerRadian); })

  # [radians] .cos [cos(radians)]
  Numeric.create_shared_method('.cos', TosSpec, [],
    &lambda {|vm| vm.push(Math::cos(Float.foorth_coerce(self))); })

  # [radians] .sin [sin(radians)]
  Numeric.create_shared_method('.sin', TosSpec, [],
    &lambda {|vm| vm.push(Math::sin(Float.foorth_coerce(self))); })

  # [radians] .tan [tan(radians)]
  Numeric.create_shared_method('.tan', TosSpec, [],
    &lambda {|vm| vm.push(Math::tan(Float.foorth_coerce(self))); })

  # [cos(radians)] .acos [radians]
  Numeric.create_shared_method('.acos', TosSpec, [],
    &lambda {|vm| vm.push(Math::acos(Float.foorth_coerce(self))); })

  # [sin(radians)] .asin [radians]
  Numeric.create_shared_method('.asin', TosSpec, [],
    &lambda {|vm| vm.push(Math::asin(Float.foorth_coerce(self))); })

  # [y/x] .atan [radians]
  Numeric.create_shared_method('.atan', TosSpec, [],
    &lambda {|vm| vm.push(Math::atan(Float.foorth_coerce(self))); })

  # [y x] .atan2 [radians]
  Numeric.create_shared_method('.atan2', TosSpec, [],
    &lambda {|vm| vm.poke(Math::atan2(Float.foorth_coerce(vm.peek), Float.foorth_coerce(self))); })

  # [radians] .cosh [cosh(radians)]
  Numeric.create_shared_method('.cosh', TosSpec, [],
    &lambda {|vm| vm.push(Math::cosh(Float.foorth_coerce(self))); })

  # [radians] .sinh [sinh(radians)]
  Numeric.create_shared_method('.sinh', TosSpec, [],
    &lambda {|vm| vm.push(Math::sinh(Float.foorth_coerce(self))); })

  # [radians] .tanh [tanh(radians)]
  Numeric.create_shared_method('.tanh', TosSpec, [],
    &lambda {|vm| vm.push(Math::tanh(Float.foorth_coerce(self))); })

  # [cosh(radians)] .acosh [radians]
  Numeric.create_shared_method('.acosh', TosSpec, [],
    &lambda {|vm| vm.push(Math::acosh(Float.foorth_coerce(self))); })

  # [sinh(radians)] .asinh [radians]
  Numeric.create_shared_method('.asinh', TosSpec, [],
    &lambda {|vm| vm.push(Math::asinh(Float.foorth_coerce(self))); })

  # [y/x] .atanh [radians]
  Numeric.create_shared_method('.atanh', TosSpec, [],
    &lambda {|vm| vm.push(Math::atanh(Float.foorth_coerce(self))); })

  # [x] .e** [e**x]
  Numeric.create_shared_method('.e**', TosSpec, [],
    &lambda {|vm| vm.push(Math::exp(self)); })
  Complex.create_shared_method('.e**', TosSpec, [],
    &lambda {|vm| vm.push(Math::E ** self); })

  # [x] .ln [ln(x)]
  Numeric.create_shared_method('.ln', TosSpec, [],
    &lambda {|vm| vm.push(Math::log(Float.foorth_coerce(self))); })

  # [x] .10** [10**x]
  Numeric.create_shared_method('.10**', TosSpec, [],
    &lambda {|vm| vm.push(10.0**self); })

  # [x] .log10 [log10(x)]
  Numeric.create_shared_method('.log10', TosSpec, [],
    &lambda {|vm| vm.push(Math::log10(Float.foorth_coerce(self))); })

  # [x] .2** [2**x]
  Numeric.create_shared_method('.2**', TosSpec, [],
    &lambda {|vm| vm.push(2.0**self); })

  # [x] .log2 [log2(x)]
  Numeric.create_shared_method('.log2', TosSpec, [],
    &lambda {|vm| vm.push(Math::log2(Float.foorth_coerce(self))); })

  # [x] .sqr [square(x)]
  Numeric.create_shared_method('.sqr', TosSpec, [],
    &lambda {|vm| vm.push(self*self); })

  # [x] .sqrt [square root(x)]
  Numeric.create_shared_method('.sqrt', TosSpec, [],
    &lambda {|vm| vm.push(Math::sqrt(self)); })
  Complex.create_shared_method('.sqrt', TosSpec, [],
    &lambda {|vm| vm.push(self ** 0.5); })

  # [x] .cube [cube(x)]
  Numeric.create_shared_method('.cube', TosSpec, [],
    &lambda {|vm| vm.push(self*self*self); })

  # [x] .cbrt [cube root(x)]
  Numeric.create_shared_method('.cbrt', TosSpec, [],
    &lambda {|vm| vm.push(Math::cbrt(self)); })
  Complex.create_shared_method('.cbrt', TosSpec, [],
    &lambda {|vm| vm.push(self ** Rational(1,3)); })

  # [x y] .hypot [sqrt(x**2 + y**2)]
  Numeric.create_shared_method('.hypot', TosSpec, [], &lambda {|vm|
    vm.poke(Math::hypot(Float.foorth_coerce(self), Float.foorth_coerce(vm.peek)));
  })

  # [r t] .p2c [x y]; Polar to Cartesian.
  Numeric.create_shared_method('.p2c', TosSpec, [], &lambda {|vm|
    radius = Float.foorth_coerce(vm.pop)
    theta  = Float.foorth_coerce(self)
    vm.push(radius * Math::cos(theta))
    vm.push(radius * Math::sin(theta))
  })

  # [x y] .c2p [r t]; Cartesian to Polar.
  Numeric.create_shared_method('.c2p', TosSpec, [], &lambda {|vm|
    real = Float.foorth_coerce(vm.pop)
    imag = Float.foorth_coerce(self)
    vm.push(Math::hypot(real,imag))
    vm.push(Math::atan2(imag,real))
  })

end
