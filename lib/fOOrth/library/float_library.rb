# coding: utf-8

#* library/float_library.rb - Float specific support for the fOOrth library.
module XfOOrth

  #Connect the Float class to the fOOrth class system.
  Float.create_foorth_proxy

  # [a] .to_f [Float or nil]
  Object.create_shared_method('.to_f', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Float(self))
    rescue
      vm.push(nil)
    end
  })

  # [a] .to_f! [Float]
  Object.create_shared_method('.to_f!', TosSpec, [],
    &lambda {|vm| vm.push(Float.foorth_coerce(self)) })

  # [num_digits a_number] .round_to [a_float]
  Numeric.create_shared_method('.round_to', TosSpec, [], &lambda {|vm|
    value = Float.foorth_coerce(self)
    digits = Integer.foorth_coerce(vm.pop)
    vm.push(value.round(digits))
  })

  # [n/d] .numerator [n]
  Float.create_shared_method('.numerator', TosSpec, [],
    &lambda {|vm| vm.push(self.rationalize.numerator); })

  # [n/d] .denominator [d]
  Float.create_shared_method('.denominator', TosSpec, [],
    &lambda {|vm| vm.push(self.rationalize.denominator); })

end
