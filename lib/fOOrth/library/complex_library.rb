# coding: utf-8

#* library/complex_library.rb - Numeric support for the fOOrth library.
module XfOOrth

  #Connect the Complex class to the fOOrth class system.
  Complex.create_foorth_proxy

  #Some complex stubs.
  Complex.create_shared_method('mod',    NosSpec, [:stub])
  Complex.create_shared_method('.ceil',  TosSpec, [:stub])
  Complex.create_shared_method('.floor', TosSpec, [:stub])
  Complex.create_shared_method('.round', TosSpec, [:stub])
  Complex.create_shared_method('<',      NosSpec, [:stub])
  Complex.create_shared_method('>',      NosSpec, [:stub])
  Complex.create_shared_method('<=',     NosSpec, [:stub])
  Complex.create_shared_method('>=',     NosSpec, [:stub])
  Complex.create_shared_method('<=>',    NosSpec, [:stub])


  #Some conversion words.
  # [a b] complex [a+bi]
  VirtualMachine.create_shared_method('complex', VmSpec, [], &lambda {|vm|
    real,imag = popm(2)

    begin
      push(Complex(real,imag));
    rescue
      error "F40: Cannot coerce a #{real.foorth_name}, #{imag.foorth_name} to a Complex"
    end
  })

  # [a+bi] .split [a b]
  Complex.create_shared_method('.split', TosSpec, [],
    &lambda {|vm| vm.push(self.real); vm.push(self.imaginary); })

  # [a] .to_x [compleX or nil]
  Object.create_shared_method('.to_x', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Complex(self))
    rescue
      vm.push(nil)
    end
  })

  # [a] .to_x! [compleX]
  Object.create_shared_method('.to_x!', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Complex(self))
    rescue
      error "F40: Cannot coerce a #{self.foorth_name} to a Complex"
    end
  })

  # [a+bi] .imaginary [b]
  Numeric.create_shared_method('.imaginary', TosSpec, [],
    &lambda {|vm| vm.push(self.imaginary); })

  # [a+bi] .real [a]
  Numeric.create_shared_method('.real', TosSpec, [],
    &lambda {|vm| vm.push(self.real); })

  # [a+bi] .angle [atan2(b,a) or 0]
  Numeric.create_shared_method('.angle', TosSpec, [],
    &lambda {|vm| vm.push(self.angle); })

  # [a+bi] .magnitude [sqrt(a**2 + b**2)]
  Numeric.create_shared_method('.magnitude', TosSpec, [],
    &lambda {|vm| vm.push(self.magnitude); })

  # [a+bi] .conjugate [a-bi]
  # Complex convicts that behave well are allowed .conjugate visits.
  Numeric.create_shared_method('.conjugate', TosSpec, [],
    &lambda {|vm| vm.push(self.conjugate); })

  # [a+bi] .polar [magnitude angle]
  # Convert a complex number to polar format
  Numeric.create_shared_method('.polar', TosSpec, [],
    &lambda {|vm| vm.pushm(self.polar); })

end