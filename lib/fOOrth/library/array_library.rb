# coding: utf-8

#* library/array_library.rb - Array support for the fOOrth library.
module XfOOrth

  #Connect the Array class to the fOOrth class system.
  Array.create_foorth_proxy

  # [] Array .new [[]]; create an empty array.
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
    &lambda {|vm| value, index = vm.popm(2); self[index.to_i] = value; })

  # [[1 2 3]] .reverse [[3 2 1]]
  Array.create_shared_method('.reverse', TosSpec, [],
    &lambda {|vm| vm.push(self.reverse); })

  # [[3 1 2]] .sort [[1 2 3]]
  Array.create_shared_method('.sort', TosSpec, [],
    &lambda {|vm| vm.push(self.sort); })

  # [[ 1 2 3]] .shuffle [[x y z]]
  Array.create_shared_method('.shuffle', TosSpec, [],
    &lambda {|vm| vm.push(self.shuffle); })

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

  # [w [3 1 2]] .-left [2]    // Assumes w = 2
  Array.create_shared_method('.-left', TosSpec, [],
    &lambda {|vm| vm.poke(self[(vm.peek.to_i)..-1]); })

  # [w [0 8 9] [1 2 3 4]] .+left [[0 8 9 3 4]] // Assumes w = 2
  Array.create_shared_method('.+left', TosSpec, [], &lambda {|vm|
    ins = vm.pop
    vm.poke(ins + self[(vm.peek.to_i)..-1])
  })

  # [w [3 1 2]] .right [[1 2]]; assumes w = 2
  Array.create_shared_method('.right', TosSpec, [],
    &lambda {|vm| vm.poke(self.last(vm.peek.to_i)); })

  # [w [3 1 2]] .-right [[3]]   // Assumes w = 2
  Array.create_shared_method('.-right', TosSpec, [],
    &lambda {|vm| vm.poke(self[0...(0-(vm.peek.to_i))]); })

  # [w [0 8 9] [1 2 3 4]] .+right [[1 2 0 8 9]] // Assumes w = 2
  Array.create_shared_method('.+right', TosSpec, [], &lambda {|vm|
    ins = vm.pop
    width = vm.pop.to_i
    vm.push(self[0...(0-width)] + ins)
  })

  # [n w [1 2 3 4 5 6 7 8]] .mid [[3 4 5 6]] // Assumes n = 2, w = 4
  Array.create_shared_method('.mid', TosSpec, [], &lambda {|vm|
    width = vm.pop.to_i
    posn = vm.pop.to_i
    vm.push(self[posn...(posn+width)])
  })

  # [n w [1 2 3 4 5 6 7 8]] .-mid [[1 2 7 8]] // Assumes n = 2, w = 4
  Array.create_shared_method('.-mid', TosSpec, [], &lambda {|vm|
    width = vm.pop.to_i
    posn = vm.pop.to_i
    vm.push(self[0...posn] + self[(posn+width)..-1])
  })

  # [n w [0 8 9] [1 2 3 4 5 6 7 8]] .+mid [[1 2 0 8 9 7 8]] // Assumes n = 2, w = 4
  Array.create_shared_method('.+mid', TosSpec, [], &lambda {|vm|
    ins = vm.pop
    width = vm.pop.to_i
    posn = vm.pop.to_i
    vm.push(self[0...posn] + ins + self[(posn+width)..-1])
  })

  # [l r [1 2 3 4 5 6 7 8]] .midlr [[2 3 4 5 6 7]] // Assumes n = 1, w = 1
  Array.create_shared_method('.midlr', TosSpec, [], &lambda {|vm|
    right = vm.pop.to_i
    left  = vm.pop.to_i
    vm.push(self[left...(0-right)])
  })

  # [l r [1 2 3 4 5 6 7 8]] .-midlr [[1 8]] // Assumes l = 1, r = 1
  Array.create_shared_method('.-midlr', TosSpec, [], &lambda {|vm|
    right = vm.pop.to_i
    left  = vm.pop.to_i
    vm.push(self[0...left] + self[((0-right))..-1])
  })

  # [l r [0 8 9] [1 2 3 4 5 6 7 8]] .+midlr [[1 0 8 9 8]] // Assumes l = 1, r = 1
  Array.create_shared_method('.+midlr', TosSpec, [], &lambda {|vm|
    ins = vm.pop
    right = vm.pop.to_i
    left  = vm.pop.to_i
    vm.push(self[0...left] + ins + self[((0-right))..-1])
  })

  # [l 2 3 ... n] .strmax [widest]
  Array.create_shared_method('.strmax', TosSpec, [], &lambda {|vm|
    result = 0

    self.each {|item|
      item.foorth_strlen(vm)
      temp = vm.pop
      result = result > temp ? result : temp
    }

    vm.push(result)
  })

  # [l 2 3 ... n] .pp []; pretty print the array!
  Array.create_shared_method('.pp', TosSpec, [], &lambda {|vm|
    self.foorth_strmax(vm)
    width = vm.pop + 1
    cols  = (width < 79) ? (79 / width) : 1
    rows  = (self.length + cols - 1) / cols

    (0...rows).each do |row|
      (0...cols).each do |col|
        self[col*rows + row].to_foorth_s(vm)

        if cols > 1
          print vm.pop.rjust(width)
        else
          print vm.pop
        end
      end

      puts
    end
  })

end

#* Runtime library support for fOOrth constructs.
class Array

  # Runtime support for the .new{ } construct.
  def self.do_foorth_new_block(vm, &block)
    Array.new(vm.pop()) do |xloop|
      block.call(vm, xloop)
    end
  end

  # Runtime support for the .each{ } construct.
  def do_foorth_each(&block)
    self.each_with_index(&block)
  end

  # Runtime support for the .map{ } construct.
  def do_foorth_map(&block)
    index = 0
    self.map do |value|
      value = block.call(value, index)
      index += 1
      value
    end
  end

  # Runtime support for the .select{ } construct.
  def do_foorth_select(&block)
    index = 0
    self.select do |value|
      value = block.call(value, index)
      index += 1
      value
    end
  end


end
