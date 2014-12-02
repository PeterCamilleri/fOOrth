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

  # [i a] .[]@ [a[i]]
  Array.create_shared_method('.[]@', TosSpec, [],
    &lambda {|vm| vm.poke(self[vm.peek.to_i]); })

  # [v i a] .[]! []; a[i]=v
  Array.create_shared_method('.[]!', TosSpec, [],
    &lambda {|vm| value, index = vm.popm(2); self[index] = value; })

end

#* Runtime library support for fOOrth constructs.
class Array

  # Support for the .new{ } construct.
  def self.do_foorth_new_block(vm, &block)
    Array.new(vm.pop(), &block)
  end

  # Support for the .each{ } construct.
  def do_foorth_each(&block)
    self.each_with_index(&block)
  end

end
