# coding: utf-8


#* library/array_library.rb - Numeric support for the fOOrth library.
module XfOOrth

  #Connect the Array class to the fOOrth class system.
  Array.create_foorth_proxy

  # [n] Array .new_size [[0,0,...0]]; create an array of n zeros.
  Array.create_exclusive_method('.new_size', TosSpec, [],
    &lambda {|vm| vm.poke(self.new(vm.peek.to_i, 0)); })

  # [v] Array .new_value [[v]]; create an array of a single value.
  Array.create_exclusive_method('.new_value', TosSpec, [],
    &lambda {|vm| vm.poke(self.new(1, vm.peek)); })

  # [v n] Array .new_values [[v,v,...v]]; create an array of a n values.
  Array.create_exclusive_method('.new_values', TosSpec, [],
    &lambda {|vm| count = vm.pop.to_i; vm.poke(self.new(count, vm.peek)); })

  #The lambda associated with defining the local index accessor.
  Local_Index_Action = lambda {|vm|
     vm.check_deferred_mode('vm.push(xloop); ', [:new_block])
  }

  # [n] Array .new{ ... code ... } [[v1,v2,...vn]];
  # Create an array of a n values returned by the block.
  Array.create_exclusive_method('.new{', TosSpec, [:immediate],
  &lambda { |vm|
      vm.suspend_execute_mode('vm.push(Array.new(vm.pop.to_i) {|xloop| ', :new_block)

      vm.context.create_local_method('x', [:immediate], &Local_Index_Action)

      vm.context.create_local_method('}', [:immediate],
        &lambda {|vm| vm.resume_execute_mode('vm.pop}); ', [:new_block]) })
  })

end

