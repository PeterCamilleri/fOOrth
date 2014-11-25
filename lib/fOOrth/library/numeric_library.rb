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

  # Some conversion words.
  # [a] .to_n [Number]
  Object.create_shared_method('.to_n', TosSpec, [],
    &lambda {|vm| vm.push(self.to_foorth_n); })

  # [a] .to_i [Integer]
  Object.create_shared_method('.to_i', TosSpec, [],
    &lambda {|vm| vm.push(self.to_i); })

  # [a] .to_r [Rational]
  Object.create_shared_method('.to_r', TosSpec, [],
    &lambda {|vm| vm.push(self.to_r); })

  # [a] .to_f [Float]
  Object.create_shared_method('.to_f', TosSpec, [],
    &lambda {|vm| vm.push(self.to_f); })

  # [a] .to_x [compleX]
  Object.create_shared_method('.to_x', TosSpec, [],
    &lambda {|vm| vm.push(self.to_c); })


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

  # [b,a] ** [b**a]
  Numeric.create_shared_method('**', NosSpec, [],
    &lambda {|vm| vm.poke(self ** vm.peek); })

  # [b,a] / [b/a]
  Numeric.create_shared_method('/', NosSpec, [],
    &lambda {|vm| vm.poke(self / vm.peek); })

  # [b,a] mod [b%a]
  Numeric.create_shared_method('mod', NosSpec, [],
    &lambda {|vm| vm.poke(self % vm.peek); })

  # [a] neg [-a]
  Numeric.create_shared_method('neg', TosSpec, [],
    &lambda {|vm| vm.push(-self); })

  # [a] .1/x [-a]
  Numeric.create_shared_method('.1/x', TosSpec, [],
    &lambda {|vm| vm.push(1/self); })

  # [a] .abs [|a|]
  Numeric.create_shared_method('.abs', TosSpec, [],
    &lambda {|vm| vm.push(self.abs); })

  # [a] .ceil [a']; where a' is the closest integer >= a
  Numeric.create_shared_method('.ceil', TosSpec, [],
    &lambda {|vm| vm.push(self.ceil); })

  # [a] .floor [a']; where a' is the closest integer <= a
  Numeric.create_shared_method('.floor', TosSpec, [],
    &lambda {|vm| vm.push(self.floor); })

  # [a] .round [a']; where a' is the integer closest to a
  Numeric.create_shared_method('.round', TosSpec, [],
    &lambda {|vm| vm.push(self.round); })

  # [n/d] .numerator [n]
  Numeric.create_shared_method('.numerator', TosSpec, [],
    &lambda {|vm| vm.push(self.numerator); })

  # [n/d] .denominator [d]
  Numeric.create_shared_method('.denominator', TosSpec, [],
    &lambda {|vm| vm.push(self.denominator); })

  # [a+bi] .imaginary [b]
  Numeric.create_shared_method('.imaginary', TosSpec, [],
    &lambda {|vm| vm.push(self.imaginary); })

  # [a+bi] .real [a]
  Numeric.create_shared_method('.real', TosSpec, [],
    &lambda {|vm| vm.push(self.real); })






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

  #Advanced math stuff!
  # [] pi [3.141592653589793]
  Object.create_shared_method('pi', MacroSpec, ["vm.push(Math::PI)"])

  # [] e [2.718281828459045]
  Object.create_shared_method('e', MacroSpec, ["vm.push(Math::E)"])

  #The number of degrees in one radian.
  DegreesPerRadian = 180.0/Math::PI

  # [degrees] .d2r [radians]
  Numeric.create_shared_method('.d2r', TosSpec, [],
    &lambda {|vm| vm.push(self/DegreesPerRadian); })

  # [radians] .r2d [degrees]
  Numeric.create_shared_method('.r2d', TosSpec, [],
    &lambda {|vm| vm.push(self*DegreesPerRadian); })

  # [radians] .cos [cos(radians)]
  Numeric.create_shared_method('.cos', TosSpec, [],
    &lambda {|vm| vm.push(Math::cos(self)); })

  # [radians] .sin [sin(radians)]
  Numeric.create_shared_method('.sin', TosSpec, [],
    &lambda {|vm| vm.push(Math::sin(self)); })

  # [radians] .tan [tan(radians)]
  Numeric.create_shared_method('.tan', TosSpec, [],
    &lambda {|vm| vm.push(Math::tan(self)); })

  # [cos(radians)] .acos [radians]
  Numeric.create_shared_method('.acos', TosSpec, [],
    &lambda {|vm| vm.push(Math::acos(self)); })

  # [sin(radians)] .asin [radians]
  Numeric.create_shared_method('.asin', TosSpec, [],
    &lambda {|vm| vm.push(Math::asin(self)); })

  # [y/x] .atan [radians]
  Numeric.create_shared_method('.atan', TosSpec, [],
    &lambda {|vm| vm.push(Math::atan(self)); })

  # [y x] .atan2 [radians]
  Numeric.create_shared_method('.atan2', TosSpec, [],
    &lambda {|vm| vm.poke(Math::atan2(vm.peek, self)); })

  # [x] .e** [e**x]
  Numeric.create_shared_method('.e**', TosSpec, [],
    &lambda {|vm| vm.push(Math::exp(self)); })

  # [x] .ln [ln(x)]
  Numeric.create_shared_method('.ln', TosSpec, [],
    &lambda {|vm| vm.push(Math::log(self)); })

  # [x] .10** [10**x]
  Numeric.create_shared_method('.10**', TosSpec, [],
    &lambda {|vm| vm.push(10.0**self); })

  # [x] .log10 [log10(x)]
  Numeric.create_shared_method('.log10', TosSpec, [],
    &lambda {|vm| vm.push(Math::log10(self)); })

  # [x] .2** [2**x]
  Numeric.create_shared_method('.2**', TosSpec, [],
    &lambda {|vm| vm.push(2.0**self); })

  # [x] .log2 [log2(x)]
  Numeric.create_shared_method('.log2', TosSpec, [],
    &lambda {|vm| vm.push(Math::log2(self)); })

  # [x] .sqrt [square root(x)]
  Numeric.create_shared_method('.sqrt', TosSpec, [],
    &lambda {|vm| vm.push(Math::sqrt(self)); })

  # [x] .cbrt [cube root(x)]
  Numeric.create_shared_method('.cbrt', TosSpec, [],
    &lambda {|vm| vm.push(Math::cbrt(self)); })

  # [x y] .hypot [sqrt(x**2 + y**2)]
  Numeric.create_shared_method('.hypot', TosSpec, [],
    &lambda {|vm| vm.poke(Math::hypot(self, vm.peek)); })

end
