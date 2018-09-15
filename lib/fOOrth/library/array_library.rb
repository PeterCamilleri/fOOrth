# coding: utf-8

#* library/array_library.rb - Array support for the fOOrth library.
module XfOOrth

  #Connect the Array class to the fOOrth class system.
  Array.create_foorth_proxy

  # [] Array .new [[]]; create an empty array.
  # The default implementation from Object is used for this.

  # [n] Array .new_size [[0,0,...0]]; create an array of n zeros.
  Array.create_exclusive_method('.new_size', TosSpec, [], &lambda {|vm|
    begin
      vm.poke(self.new(Integer.foorth_coerce(vm.peek), 0));
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [v] Array .new_value [[v]]; create an array of a single value.
  Array.create_exclusive_method('.new_value', TosSpec, [],
    &lambda {|vm| vm.poke(self.new(1, vm.peek)); })

  # [v n] Array .new_values [[v,v,...v]]; create an array of a n values.
  Array.create_exclusive_method('.new_values', TosSpec, [], &lambda {|vm|
    begin
      count = Integer.foorth_coerce(vm.pop)
      vm.poke(self.new(count, vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [n] Array .new{{ ... }} [[array]]; create an array of a n computed values.
  Array.create_exclusive_method('.new{{', NosSpec, [], &lambda {|vm|
    block = vm.pop
    count = Integer.foorth_coerce(vm.pop)

    vm.push(Array.new(count) { |idx| block.call(vm, nil, idx); vm.pop})
  })

  # [array] .map{{ ... }} [mapped_array]
  Array.create_shared_method('.map{{', NosSpec, [], &lambda { |vm|
    idx, block = 0, vm.pop
    vm.push(self.map{|val| block.call(vm, val, idx); idx += 1; vm.pop})
  })

  # [array] .select{{ ... }} [selected_array]
  Array.create_shared_method('.select{{', NosSpec, [], &lambda { |vm|
    idx, block = 0, vm.pop
    vm.push(self.select { |val| block.call(vm, val, idx); idx += 1; vm.pop})
  })

  # [] [ v1 v2 ... vn ] [[v1,v2,...vn]]; an array literal value
  VirtualMachine.create_shared_method('[', VmSpec, [:immediate], &lambda { |vm|
    vm.nest_mode('vm.squash; ', :array_literal)

    vm.context.create_local_method(']', LocalSpec, [:immediate],
      &lambda {|vm| vm.unnest_mode('vm.unsquash; ', [:array_literal]) })
  })

  # [array] .each{{ ... }} [unspecified]
  Array.create_shared_method('.each{{', NosSpec, [], &lambda { |vm|
    block = vm.pop
    self.each_with_index { |val, idx| block.call(vm, val, idx) }
  })

  # Some basic data access words.
  # [a] @ [a[0]]
  Array.create_shared_method('@', TosSpec, [], &lambda { |vm|
    vm.push(self[0])
  })

  # [ v a ] ! [], a[0] = v
  Array.create_shared_method('!', TosSpec, [], &lambda { |vm|
    self[0] = vm.pop
  })

  # [ i a ] .[]@ [ a[i] ]
  Array.create_shared_method('.[]@', TosSpec, [], &lambda {|vm|
    begin
      vm.poke(self[Integer.foorth_coerce(vm.peek)])
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [ v i a ] .[]! []; a[i]=v
  Array.create_shared_method('.[]!', TosSpec, [], &lambda {|vm|
    value, index = vm.popm(2)
    self[Integer.foorth_coerce(index)] = value
  })

  # [ [ 1 2 3 ] ] .reverse [ [ 3 2 1 ] ]
  Array.create_shared_method('.reverse', TosSpec, [],
    &lambda {|vm| vm.push(self.reverse) })

  # [ [ 3 1 2 ] ] .sort [ [ 1 2 3 ] ]
  Array.create_shared_method('.sort', TosSpec, [],
    &lambda {|vm| vm.push(self.sort {|va,vb| va <=> va.foorth_coerce(vb)}) })

  # [ [ 1 2 3 ] ] .shuffle  [ [ x y z ] ]
  Array.create_shared_method('.shuffle', TosSpec, [],
    &lambda {|vm| vm.push(self.shuffle) })

  # [ [ 3 1 2 ] ] .length [ 3 ]
  Array.create_shared_method('.length', TosSpec, [],
    &lambda {|vm| vm.push(self.length) })

  # [ an_array ] .empty? [ a_boolean ]
  Array.create_shared_method('.empty?', TosSpec, [],
    &lambda {|vm| vm.push(self.empty?) })

  # [ an_array ] .present? [ a_boolean ]
  Array.create_shared_method('.present?', TosSpec, [],
    &lambda {|vm| vm.push(!self.empty?) })

  # [ an_array ] .clear! [ ]; The array contents are removed.
  Array.create_shared_method('.clear!', TosSpec, [],
    &lambda {|vm| self.clear})

  # [ [ 3 1 2 ] n ] << [ [ 3 1 2 n ] ]
  Array.create_shared_method('<<', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self << vm.peek)
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [ [ 3 1 2 ] n ] >> [ [ n 3 1 2 ] ]
  Array.create_shared_method('>>', NosSpec, [], &lambda {|vm|
    begin
      vm.poke(self.insert(0, vm.peek))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [[3 1 2] n] + [[3 1 2 n]]
  Array.create_shared_method('+', NosSpec, [],
    &lambda {|vm| vm.poke(self + vm.peek.in_array) })


  # The LEFT group
  # [w [ 3 1 2 ] ] .left [ [ 3 1 ] ]; assumes w = 2
  Array.create_shared_method('.left', TosSpec, [], &lambda {|vm|
    begin
      width = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid width: #{width} in .left" if width < 0
      vm.poke(self.first(width))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [w [ 3 1 2 ] ] .-left [ 2 ]    // Assumes w = 2
  Array.create_shared_method('.-left', TosSpec, [], &lambda {|vm|
    begin
      width = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid width: #{width} in .-left" if width < 0
      vm.poke(self[width..-1])
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [w [ 0 8 9 ] [ 1 2 3 4 ] ] .+left [ [ 0 8 9 3 4 ] ] // Assumes w = 2
  Array.create_shared_method('.+left', TosSpec, [], &lambda {|vm|
    begin
      ins = vm.pop.in_array
      width = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid width: #{width} in .+left" if width < 0
      vm.poke(ins + self[width..-1])
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [w [ 1 2 3 4 ] ] .^left [ [ 3 4 ] [ 1 2 ] ]; assumes w = 2
  Array.create_shared_method('.^left', TosSpec, [], &lambda {|vm|
    begin
      width = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid width: #{width} in .^left" if width < 0

      vm.poke(self[width..-1])
      vm.push(self.first(width))
    rescue
      vm.data_stack.pop
      raise
    end
  })


  #The RIGHT group
  # [w [ 3 1 2 ] ] .right [ [ 1 2 ] ]; assumes w = 2
  Array.create_shared_method('.right', TosSpec, [], &lambda {|vm|
    begin
      width = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid width: #{width} in .right" if width < 0
      vm.poke(self.last(width))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [w [ 3 1 2 ] ] .-right [ [ 3 ] ]   // Assumes w = 2
  Array.create_shared_method('.-right', TosSpec, [], &lambda {|vm|
    begin
      width = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid width: #{width} in .-right" if width < 0
      vm.poke(self[0...(0-width)])
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [w [ 0 8 9 ] [ 1 2 3 4 ] ] .+right [ [ 1 2 0 8 9 ] ] // Assumes w = 2
  Array.create_shared_method('.+right', TosSpec, [], &lambda {|vm|
    begin
      ins = vm.pop.in_array
      width = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid width: #{width} in .+right" if width < 0
      vm.poke(self[0...(0-width)] + ins)
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [w [ 1 2 3 4 ] ] .^right [ [ 1 2 ] [ 3 4 ] ]; assumes w = 2
  Array.create_shared_method('.^right', TosSpec, [], &lambda {|vm|
    begin
      width = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid width: #{width} in .^right" if width < 0

      vm.poke(self[0...(0-width)])
      vm.push(self.last(width))
    rescue
      vm.data_stack.pop
      raise
    end
  })


  # The MID group
  # [n w [ 1 2 3 4 5 6 7 8 ] ] .mid [ [ 3 4 5 6 ] ] // Assumes n = 2, w = 4
  Array.create_shared_method('.mid', TosSpec, [], &lambda {|vm|
    begin
      width = Integer.foorth_coerce(vm.pop)
      posn = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid index: #{posn} in .mid"  if posn < 0
      error "F41: Invalid width: #{width} in .mid" if width < 0
      vm.poke(self[posn...(posn+width)])
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [n w [ 1 2 3 4 5 6 7 8 ] ] .-mid [ [ 1 2 7 8 ] ] // Assumes n = 2, w = 4
  Array.create_shared_method('.-mid', TosSpec, [], &lambda {|vm|
    begin
      width = Integer.foorth_coerce(vm.pop)
      posn = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid index: #{posn} in .-mid"  if posn < 0
      error "F41: Invalid width: #{width} in .-mid" if width < 0
      vm.poke(self[0...posn] + self[(posn+width)..-1])
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [n w [ 0 8 9 ] [ 1 2 3 4 5 6 7 8 ] ] .+mid [ [ 1 2 0 8 9 7 8 ] ] // Assumes n=2, w=4
  Array.create_shared_method('.+mid', TosSpec, [], &lambda {|vm|
    begin
      ins = vm.pop.in_array
      width = Integer.foorth_coerce(vm.pop)
      posn = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid index: #{posn} in .+mid"  if posn < 0
      error "F41: Invalid width: #{width} in .+mid" if width < 0
      vm.poke(self[0...posn] + ins + self[(posn+width)..-1])
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [n w [ 1 2 3 4 5 6 7 8 ] ] .^mid [ [ 1 2 7 8 ] [ 3 4 5 6 ] ] // For n=2, w=4
  Array.create_shared_method('.^mid', TosSpec, [], &lambda {|vm|
    begin
      width = Integer.foorth_coerce(vm.pop)
      posn = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid index: #{posn} in .^mid"  if posn < 0
      error "F41: Invalid width: #{width} in .^mid" if width < 0
      vm.poke(self[0...posn] + self[(posn+width)..-1])
      vm.push(self[posn...(posn+width)])
    rescue
      vm.data_stack.pop
      raise
    end
  })


  # The MIDLR group
  # [l r [ 1 2 3 4 5 6 7 8 ] ] .midlr [ [ 2 3 4 5 6 7 ] ] // Assumes l=1, r=1
  Array.create_shared_method('.midlr', TosSpec, [], &lambda {|vm|
    begin
      right = Integer.foorth_coerce(vm.pop)
      left  = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid left width: #{left} in .midlr"  if left < 0
      error "F41: Invalid right width: #{right} in .midlr" if right < 0
      vm.poke(self[left..(0-right-1)])
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [l r [ 1 2 3 4 5 6 7 8 ] ] .-midlr [ [ 1 8 ] ] // Assumes l = 1, r = 1
  Array.create_shared_method('.-midlr', TosSpec, [], &lambda {|vm|
    begin
      right = Integer.foorth_coerce(vm.pop)
      left  = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid left width: #{left} in .-midlr"  if left < 0
      error "F41: Invalid right width: #{right} in .-midlr" if right < 0
      vm.poke(self.first(left) + self.last(right))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [l r [ 0 8 9 ] [ 1 2 3 4 5 6 7 8 ] ] .+midlr [ [ 1 0 8 9 8 ] ] // Assumes l = 1, r = 1
  Array.create_shared_method('.+midlr', TosSpec, [], &lambda {|vm|
    begin
      ins = vm.pop.in_array
      right = Integer.foorth_coerce(vm.pop)
      left  = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid left width: #{left} in .-midlr"  if left < 0
      error "F41: Invalid right width: #{right} in .-midlr" if right < 0
      vm.poke(self.first(left) + ins + self.last(right))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [l r [ 1 2 3 4 5 ] ] .midlr [ [ 1 5 ] [ 2 3 4 ] ] // Assumes l=1, r=1
  Array.create_shared_method('.^midlr', TosSpec, [], &lambda {|vm|
    begin
      right = Integer.foorth_coerce(vm.pop)
      left  = Integer.foorth_coerce(vm.peek)
      error "F41: Invalid left width: #{left} in .midlr"  if left < 0
      error "F41: Invalid right width: #{right} in .midlr" if right < 0
      vm.poke(self.first(left) + self.last(right))
      vm.push(self[left..(0-right-1)])
    rescue
      vm.data_stack.pop
      raise
    end
  })


  #The DEQUEUE LEFT group
  #[ [ 1 2 3 ] ] .pop_left [ [ 2 3 ] 1 ]
  Array.create_shared_method('.pop_left', TosSpec, [], &lambda{|vm|
    error "F31: Array underflow error on .pop_left" if self.empty?
    vm.push(self[1..-1])
    vm.push(self.first)
  })

  #[ [ 1 2 3 ] ] .pop_left! [ 1 ]; Mutates original array.
  Array.create_shared_method('.pop_left!', TosSpec, [], &lambda{|vm|
    error "F31: Array underflow error on .pop_left!" if self.empty?
    vm.push(self.delete_at(0))
  })

  #[ 0 [ 1 2 3 ] ] .push_left [ [ 0 1 2 3 ] ]
  Array.create_shared_method('.push_left', TosSpec, [], &lambda{|vm|
    vm.poke([ vm.peek ] + self)
  })

  #[ 0 [ 1 2 3 ] ] .push_left! [ ]; Mutates original array.
  Array.create_shared_method('.push_left!', TosSpec, [], &lambda{|vm|
    self.insert(0, vm.pop)
  })

  #[ [ 1 2 3 ] ] .peek_left [ [ 1 2 3 ] 1 ]
  Array.create_shared_method('.peek_left', TosSpec, [], &lambda{|vm|
    error "F31: Array underflow error on .peek_left" if self.empty?
    vm.push(self)
    vm.push(self.first)
  })

  #[ [ 1 2 3 ] ] .peek_left! [ 1 ]
  Array.create_shared_method('.peek_left!', TosSpec, [], &lambda{|vm|
    error "F31: Array underflow error on .peek_left!" if self.empty?
    vm.push(self.first)
  })


  #The DEQUEUE RIGHT group
  #[ [ 1 2 3 ] ] .pop_right [ [ 1 2 ] 3 ]
  Array.create_shared_method('.pop_right', TosSpec, [], &lambda{|vm|
    error "F31: Array underflow error on .pop_right" if self.empty?
    vm.push(self[0...-1])
    vm.push(self.last)
  })

  #[ [ 1 2 3 ] ] .pop_right! [ 3 ]; Mutates original array.
  Array.create_shared_method('.pop_right!', TosSpec, [], &lambda{|vm|
    error "F31: Array underflow error on .pop_right!" if self.empty?
    vm.push(self.pop)
  })

  #[ 4 [ 1 2 3 ] ] .push_right [ [ 1 2 3 4 ] ]
  Array.create_shared_method('.push_right', TosSpec, [], &lambda{|vm|
    vm.poke(self + [ vm.peek ])
  })

  #[ 4 [ 1 2 3 ] ] .push_right! [ ]; Mutates original array.
  Array.create_shared_method('.push_right!', TosSpec, [], &lambda{|vm|
    self << vm.pop
  })

  #[ [ 1 2 3 ] ] .peek_right [ [ 1 2 3 ] 3 ]
  Array.create_shared_method('.peek_right', TosSpec, [], &lambda{|vm|
    error "F31: Array underflow error on .peek_right" if self.empty?
    vm.push(self)
    vm.push(self.last)
  })

  #[ [ 1 2 3 ] ] .peek_right! [ [ 1 2 3 ] 3 ]
  Array.create_shared_method('.peek_right!', TosSpec, [], &lambda{|vm|
    error "F31: Array underflow error on .peek_right!" if self.empty?
    vm.push(self.last)
  })


  # [ a ] .min [ smallest_element ]
  Array.create_shared_method('.min', TosSpec, [], &lambda {|vm|
    result = self[0]

    self.each do |value|
      other = result.foorth_coerce(value)
      result = other if result > other
    end

    vm.push(result)
  })

  # [ a ] .max [ largest_element ]
  Array.create_shared_method('.max', TosSpec, [], &lambda {|vm|
    result = self[0]

    self.each do |value|
      other = result.foorth_coerce(value)
      result = other if result < other
    end

    vm.push(result)
  })

  # [ array ] .split [ a0 a1 ... aN ]
  Array.create_shared_method('.split', TosSpec, [], &lambda {|vm|
    vm.pushm(self)
  })

  # [ a1 a2 aN N ] .join [ [ a1 a2 ... aN ] ]
  Integer.create_shared_method('.join', TosSpec, [], &lambda {|vm|
    error "F30: Invalid array size: .join" if self < 0
    vm.push(vm.popm(self))
  })

  # [ array ] .to_s [ string ]
  Array.create_shared_method('.to_s', TosSpec, [], &lambda {|vm|
    result = "[ "

    self.each do |value|
      if value.is_a?(String) || value.nil?
        result << value.inspect + " "
      else
        value.to_foorth_s(vm)
        result << (vm.pop || value.inspect) + " "
      end
    end

    vm.push((result + "]").freeze)
  })

  # [ l 2 3 ... n ] .strmax [ widest ]
  Array.create_shared_method('.strmax', TosSpec, [], &lambda {|vm|
    result = 0

    self.each {|item|
      item.foorth_strlen(vm)
      temp = vm.pop
      result = result > temp ? result : temp
    }

    vm.push(result)
  })

  #[ array ] .scatter [ a0 a1 ... aN ]
  Array.create_shared_method('.scatter', TosSpec, [], &lambda {|vm|
    vm.data_stack += self
  })

  #[ x0 x1 ... xN] gather [ array ]
  VirtualMachine.create_shared_method('gather', VmSpec, [], &lambda{|vm|
    @data_stack = [@data_stack]
  })

  #[ x0 x1 ... xN N] .gather [ array ]
  Integer.create_shared_method('.gather', TosSpec, [], &lambda {|vm|
    error "F30: Invalid .gather count value." unless self > 0
    error "F30: Data stack underflow." unless self <= vm.data_stack.length

    temp = vm.data_stack.pop(self)
    vm.data_stack << temp
  })

  #[ an_array ] .to_a [ an_array ]
  Array.create_shared_method('.to_a', TosSpec, [],
    &lambda {|vm| vm.push(self) })

  #[ an_array ] .to_h [ a_hash ]
  Array.create_shared_method('.to_h', TosSpec, [], &lambda {|vm|
    result = {}
    self.each_with_index { |val, idx| result[idx] = val }
    vm.push(result)
  })

  #[ an_array ] .values [ an_array ]
  Array.create_shared_method('.values', TosSpec, [],
    &lambda {|vm| vm.push(self) })

  #[ an_array ] .keys [ an_array ]
  Array.create_shared_method('.keys', TosSpec, [],
    &lambda {|vm| vm.push((0...self.length).to_a) })

end
