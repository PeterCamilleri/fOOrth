# coding: utf-8

#* library/standard_library.rb - The standard fOOrth library.
module XfOOrth

  # Some basic "constant" value words.
  #The self method.
  Object.create_shared_method('self', MacroWordSpec,
    ["vm.push(self); "])

  #The true method.
  Object.create_shared_method('true', MacroWordSpec,
    ["vm.push(true); "])

  #The false method.
  Object.create_shared_method('false', MacroWordSpec,
    ["vm.push(false); "])

  #The nil method.
  Object.create_shared_method('nil', MacroWordSpec,
    ["vm.push(nil); "])

  # Some stack manipulation words.
  # [a] drop []
  VirtualMachine.create_shared_method('drop', MacroWordSpec,
    ["vm.pop(); "])

  # [a] dup [a, a]
  VirtualMachine.create_shared_method('dup', MacroWordSpec,
    ["vm.push(vm.peek()); "])

  # [a] clone [a, a']
  VirtualMachine.create_shared_method('clone', MacroWordSpec,
    ["vm.push(vm.peek.full_clone); "])

  # [a] .clone [a']
  Object.create_shared_method('.clone', MonadicWordSpec, [],
    &lambda {|vm| vm.push(self.full_clone); })

  # [a] ?dup if a is true then [a,a] else [a]
  VirtualMachine.create_shared_method('?dup', VmWordSpec, [],
    &lambda {|vm| if peek?() then push(peek()); end; })

  # [b,a] swap [a,b]
  VirtualMachine.create_shared_method('swap', VmWordSpec, [],
    &lambda {|vm| vb,va = popm(2); push(va); push(vb); })

  # [c,b,a] rot [b,a,c]
  VirtualMachine.create_shared_method('rot', VmWordSpec, [],
    &lambda {|vm| vc,vb,va = popm(3); push(vb); push(va); push(vc); })

  # [b,a] over [b,a,b]
  VirtualMachine.create_shared_method('over', MacroWordSpec,
    ["vm.push(vm.peek(2)); "])

  # [di,..d2,d1,i] pick [di,..d2,d1,di]
  VirtualMachine.create_shared_method('pick', MacroWordSpec,
    ["vm.push(vm.peek(vm.pop())); "])

  # [b,a] nip [a]
  VirtualMachine.create_shared_method('nip', MacroWordSpec,
    ["vm.swap_pop(); "])

  # [b,a] tuck [a,b,a]
  VirtualMachine.create_shared_method('tuck', VmWordSpec, [],
    &lambda {|vm| vb,va = popm(2); push(va); push(vb); push(va); })

  # Some stack arithmetic words.
  # [b,a] + [b+a]
  Object.create_shared_method('+', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self + vm.pop()); })

  # [b,a] - [b-a]
  Object.create_shared_method('-', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self - vm.pop()); })

  # [b,a] * [b+a]
  Object.create_shared_method('*', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self * vm.pop()); })

  # [b,a] / [b-a]
  Object.create_shared_method('/', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self / vm.pop()); })

  # [b,a] mod [b-a]
  Object.create_shared_method('mod', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self % vm.pop()); })

  # [a] 0- [0-a]
  Object.create_shared_method('0-', MonadicWordSpec, [],
    &lambda {|vm| vm.push(0-self); })

  # Some bitwise operation words.
  # [b,a] and [b&a]
  Object.create_shared_method('and', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self.to_i & vm.pop.to_i); })

  # [b,a] or [b|a]
  Object.create_shared_method('or', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self.to_i | vm.pop.to_i); })

  # [b,a] xor [b^a]
  Object.create_shared_method('xor', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self.to_i ^ vm.pop.to_i); })

  # [a] not [~a]
  Object.create_shared_method('not', MonadicWordSpec, [],
    &lambda {|vm| vm.push(~(self.to_i)); })

  # Some boolean operation words.
  # [b,a] && [b&a]
  Object.create_shared_method('&&', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self.to_foorth_b & vm.pop.to_foorth_b); })

  # [b,a] || [b|a]
  Object.create_shared_method('||', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self.to_foorth_b | vm.pop.to_foorth_b); })

  # [b,a] ^^ [b^a]
  Object.create_shared_method('^^', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self.to_foorth_b ^ vm.pop.to_foorth_b); })

  # [a] ! [!a]
  Object.create_shared_method('!', MonadicWordSpec, [],
    &lambda {|vm| vm.push(!(self.to_foorth_b)); })

  # Some comparison words.
  # [b,a] = if b == a then [true] else [false]
  Object.create_shared_method('=', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self == vm.pop()); })

  # [b,a] <> if b != a then [true] else [false]
  Object.create_shared_method('<>', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self != vm.pop()); })

  # [b,a] > if b > a then [true] else [false]
  Object.create_shared_method('>', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self > vm.pop()); })

  # [b,a] < if b < a then [true] else [false]
  Object.create_shared_method('<', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self < vm.pop()); })

  # [b,a] >= if b >= a then [true] else [false]
  Object.create_shared_method('>=', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self >= vm.pop()); })

  # [b,a] <= if b <= a then [true] else [false]
  Object.create_shared_method('<=', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self <= vm.pop()); })

  # [b,a] 0<=> b < a [-1], b = a [0], b > a [1]
  Object.create_shared_method('<=>', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self <=> vm.pop()); })

  # Some identity comparison words.
  # [b,a] identical? if b.object_id == a.object_id then [true] else [false]
  Object.create_shared_method('identical?', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self.object_id == vm.pop.object_id); })

  # [b,a] distinct? if b.object_id != a.object_id then [true] else [false]
  Object.create_shared_method('distinct?', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self.object_id != vm.pop.object_id); })

  # Some comparison with zero words.
  # [b,a] 0= if b == 0 then [true] else [false]
  Object.create_shared_method('0=', MonadicWordSpec, [],
    &lambda {|vm| vm.push(self == 0); })

  # [b,a] 0<> if b != 0 then [true] else [false]
  Object.create_shared_method('0<>', MonadicWordSpec, [],
    &lambda {|vm| vm.push(self != 0); })

  # [b,a] 0> if b > 0 then [true] else [false]
  Object.create_shared_method('0>', MonadicWordSpec, [],
    &lambda {|vm| vm.push(self > 0); })

  # [b,a] 0< if b < 0 then [true] else [false]
  Object.create_shared_method('0<', MonadicWordSpec, [],
    &lambda {|vm| vm.push(self < 0); })

  # [b,a] 0>= if b >= 0 then [true] else [false]
  Object.create_shared_method('0>=', MonadicWordSpec, [],
    &lambda {|vm| vm.push(self >= 0); })

  # [b,a] 0<= if b <= 0 then [true] else [false]
  Object.create_shared_method('0<=', MonadicWordSpec, [],
    &lambda {|vm| vm.push(self <= 0); })

  # [b] 0<=> b < 0 [-1], b = 0 [0], b > 0 [1]
  Object.create_shared_method('0<=>', MonadicWordSpec, [],
    &lambda {|vm| vm.push(self <=> 0); })

end
