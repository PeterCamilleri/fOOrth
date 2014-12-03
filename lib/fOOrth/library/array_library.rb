# coding: utf-8

#* library/array_library.rb - Numeric support for the fOOrth library.
module XfOOrth

  #Connect the Array class to the fOOrth class system.
  Array.create_foorth_proxy

  # [] Array .new [[]]; create an array of n zeros.
  # The default implementation from Object is used for this.

  # [n] Array .new_size [[0,0,...0]]; create an array of n zeros.
  Array.create_exclusive_method('.new_size', TosSpec, [],
    &lambda {|vm| vm.poke(self.new(vm.peek.to_i, 0)); })

  # [v] Array .new_value [[v]]; create an array of a single value.
  Array.create_exclusive_method('.new_value', TosSpec, [],
    &lambda {|vm| vm.poke(self.new(1, vm.peek)); })

  # [v n] Array .new_values [[v,v,...v]]; create an array of a n values.
  Array.create_exclusive_method('.new_values', TosSpec, [],
    &lambda {|vm| count = vm.pop.to_i; vm.poke(self.new(count, vm.peek)); })

  # [] [ v1 v2 ... vn ] [[v1,v2,...vn]]; an array literal value
  VirtualMachine.create_shared_method('[', VmSpec, [:immediate], &lambda { |vm|
    vm.suspend_execute_mode('vm.squash; ', :array_literal)

    vm.context.create_local_method(']', [:immediate],
      &lambda {|vm| vm.resume_execute_mode('vm.unsquash; ', [:array_literal]) })
  })

  # [i a] .[]@ [a[i]]
  Array.create_shared_method('.[]@', TosSpec, [],
    &lambda {|vm| vm.poke(self[vm.peek.to_i]); })

  # [v i a] .[]! []; a[i]=v
  Array.create_shared_method('.[]!', TosSpec, [],
    &lambda {|vm| value, index = vm.popm(2); self[index] = value; })

  # [[1 2 3]] .reverse [[3 2 1]]
  Array.create_shared_method('.reverse', TosSpec, [],
    &lambda {|vm| vm.push(self.reverse); })

  # [[3 1 2]] .sort [[1 2 3]]
  Array.create_shared_method('.sort', TosSpec, [],
    &lambda {|vm| vm.push(self.sort); })

  # [[3 1 2]] .length [3]]
  Array.create_shared_method('.length', TosSpec, [],
    &lambda {|vm| vm.push(self.length); })

  # [[3 1 2] n] << [[3 1 2 n]]
  Array.create_shared_method('<<', NosSpec, [],
    &lambda {|vm| vm.poke(self << vm.peek); })

  # [[3 1 2] n] + [[3 1 2 n]]
  Array.create_shared_method('+', NosSpec, [],
    &lambda {|vm| vm.poke(self + vm.peek.to_foorth_p); })

  # [w [3 1 2]] .left [[3 1]]; assumes w = 2
  Array.create_shared_method('.left', TosSpec, [],
    &lambda {|vm| vm.poke(self.first(vm.peek.to_i)); })

end

#* Runtime library support for fOOrth constructs.
class Array

  # Runtime support for the .new{ } construct.
  def self.do_foorth_new_block(vm, &block)
    Array.new(vm.pop(), &block)
  end

  # Runtime support for the .each{ } construct.
  def do_foorth_each(&block)
    self.each_with_index(&block)
  end

end
