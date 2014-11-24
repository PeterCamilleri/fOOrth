# coding: utf-8

#* library/standard_library.rb - The standard fOOrth library.
module XfOOrth

  # Some basic "constant" value words.
  #The self method.
  Object.create_shared_method('self', MacroSpec, ["vm.push(self); "])

  #The true method.
  Object.create_shared_method('true', MacroSpec, ["vm.push(true); "])

  #The false method.
  Object.create_shared_method('false', MacroSpec, ["vm.push(false); "])

  #The nil method.
  Object.create_shared_method('nil', MacroSpec, ["vm.push(nil); "])

  # Some stack manipulation words.
  # [a] drop []
  VirtualMachine.create_shared_method('drop', MacroSpec,
    ["vm.pop(); "])

  # [a] dup [a, a]
  VirtualMachine.create_shared_method('dup', MacroSpec,
    ["vm.push(vm.peek()); "])

  # [a] clone [a, a']
  VirtualMachine.create_shared_method('clone', MacroSpec,
    ["vm.push(vm.peek.full_clone); "])

  # [a] .clone [a']
  Object.create_shared_method('.clone', TosSpec, [],
    &lambda {|vm| vm.push(self.full_clone); })

  # [a] ?dup if a is true then [a,a] else [a]
  VirtualMachine.create_shared_method('?dup', VmSpec, [],
    &lambda {|vm| if peek?() then push(peek()); end; })

  # [b,a] swap [a,b]
  VirtualMachine.create_shared_method('swap', VmSpec, [],
    &lambda {|vm| vb,va = popm(2); push(va); push(vb); })

  # [c,b,a] rot [b,a,c]
  VirtualMachine.create_shared_method('rot', VmSpec, [],
    &lambda {|vm| vc,vb,va = popm(3); push(vb); push(va); push(vc); })

  # [b,a] over [b,a,b]
  VirtualMachine.create_shared_method('over', MacroSpec,
    ["vm.push(vm.peek(2)); "])

  # [di,..d2,d1,i] pick [di,..d2,d1,di]
  VirtualMachine.create_shared_method('pick', MacroSpec,
    ["vm.push(vm.peek(vm.pop())); "])

  # [b,a] nip [a]
  VirtualMachine.create_shared_method('nip', MacroSpec,
    ["vm.swap_pop(); "])

  # [b,a] tuck [a,b,a]
  VirtualMachine.create_shared_method('tuck', VmSpec, [],
    &lambda {|vm| vb,va = popm(2); push(va); push(vb); push(va); })

  # Stubs for the stack arithmetic words.
  Object.create_shared_method('+',   NosSpec, [:stub])
  Object.create_shared_method('-',   NosSpec, [:stub])
  Object.create_shared_method('*',   NosSpec, [:stub])
  Object.create_shared_method('/',   NosSpec, [:stub])
  Object.create_shared_method('mod', NosSpec, [:stub])
  Object.create_shared_method('neg', TosSpec, [:stub])

  # Some bitwise operation words.
  # [b,a] and [b&a]
  Object.create_shared_method('and', TosSpec, [],
    &lambda {|vm| vm.poke(self.to_i & vm.peek.to_i); })

  # [b,a] or [b|a]
  Object.create_shared_method('or', TosSpec, [],
    &lambda {|vm| vm.poke(self.to_i | vm.peek.to_i); })

  # [b,a] xor [b^a]
  Object.create_shared_method('xor', TosSpec, [],
    &lambda {|vm| vm.poke(self.to_i ^ vm.peek.to_i); })

  # [a] com [~a]
  Object.create_shared_method('com', TosSpec, [],
    &lambda {|vm| vm.push(~(self.to_i)); })

  # Some boolean operation words.
  # [b,a] && [b&a]
  Object.create_shared_method('&&', TosSpec, [],
    &lambda {|vm| vm.poke(self.to_foorth_b && vm.peek?); })

  # [b,a] || [b|a]
  Object.create_shared_method('||', TosSpec, [],
    &lambda {|vm| vm.poke(self.to_foorth_b || vm.peek?); })

  # [b,a] ^^ [b^a]
  Object.create_shared_method('^^', TosSpec, [],
    &lambda {|vm| vm.poke(self.to_foorth_b ^ vm.peek?); })

  # [a] not [!a]
  Object.create_shared_method('not', TosSpec, [],
    &lambda {|vm| vm.push(!(self.to_foorth_b)); })

  # Some comparison words.
  # [b,a] = if b == a then [true] else [false]
  Object.create_shared_method('=', NosSpec, [],
    &lambda {|vm| vm.push(self == vm.pop()); })

  # [b,a] <> if b != a then [true] else [false]
  Object.create_shared_method('<>', NosSpec, [],
    &lambda {|vm| vm.push(self != vm.pop()); })

  # [b,a] > if b > a then [true] else [false]
  Object.create_shared_method('>', NosSpec, [],
    &lambda {|vm| vm.push(self > vm.pop()); })

  # [b,a] < if b < a then [true] else [false]
  Object.create_shared_method('<', NosSpec, [],
    &lambda {|vm| vm.push(self < vm.pop()); })

  # [b,a] >= if b >= a then [true] else [false]
  Object.create_shared_method('>=', NosSpec, [],
    &lambda {|vm| vm.push(self >= vm.pop()); })

  # [b,a] <= if b <= a then [true] else [false]
  Object.create_shared_method('<=', NosSpec, [],
    &lambda {|vm| vm.push(self <= vm.pop()); })

  # [b,a] 0<=> b < a [-1], b = a [0], b > a [1]
  Object.create_shared_method('<=>', NosSpec, [],
    &lambda {|vm| vm.push(self <=> vm.pop()); })

  # Some identity comparison words.
  # [b,a] identical? if b.object_id == a.object_id then [true] else [false]
  Object.create_shared_method('identical?', NosSpec, [],
    &lambda {|vm| vm.push(self.object_id == vm.pop.object_id); })

  # [b,a] distinct? if b.object_id != a.object_id then [true] else [false]
  Object.create_shared_method('distinct?', NosSpec, [],
    &lambda {|vm| vm.push(self.object_id != vm.pop.object_id); })

  # Some comparison with zero words.
  # [b,a] 0= if b == 0 then [true] else [false]
  Object.create_shared_method('0=', TosSpec, [],
    &lambda {|vm| vm.push(self == 0); })

  # [b,a] 0<> if b != 0 then [true] else [false]
  Object.create_shared_method('0<>', TosSpec, [],
    &lambda {|vm| vm.push(self != 0); })

  # [b,a] 0> if b > 0 then [true] else [false]
  Object.create_shared_method('0>', TosSpec, [],
    &lambda {|vm| vm.push(self > 0); })

  # [b,a] 0< if b < 0 then [true] else [false]
  Object.create_shared_method('0<', TosSpec, [],
    &lambda {|vm| vm.push(self < 0); })

  # [b,a] 0>= if b >= 0 then [true] else [false]
  Object.create_shared_method('0>=', TosSpec, [],
    &lambda {|vm| vm.push(self >= 0); })

  # [b,a] 0<= if b <= 0 then [true] else [false]
  Object.create_shared_method('0<=', TosSpec, [],
    &lambda {|vm| vm.push(self <= 0); })

  # [b] 0<=> b < 0 [-1], b = 0 [0], b > 0 [1]
  Object.create_shared_method('0<=>', TosSpec, [],
    &lambda {|vm| vm.push(self <=> 0); })

end
