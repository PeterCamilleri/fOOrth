# coding: utf-8

#* library/standard_library.rb - The standard fOOrth library.
module XfOOrth

  #===================================================
  # Some basic "constant" value words.
  #===================================================

  #The self method.
  @object_class.create_shared_method('self', MacroWordSpec,
    ['"vm.push(self); "'])

  #The true method.
  @object_class.create_shared_method('true', MacroWordSpec,
    ['"vm.push(true); "'])

  #The false method.
  @object_class.create_shared_method('false', MacroWordSpec,
    ['"vm.push(false); "'])

  #The nil method.
  @object_class.create_shared_method('nil', MacroWordSpec,
    ['"vm.push(nil); "'])


  #===================================================
  # Some stack manipulation words.
  #===================================================

  # [a] drop []
  @object_class.create_shared_method('drop', MacroWordSpec,
    ['"vm.pop(); "'])

  # [a] dup [a, a]
  @object_class.create_shared_method('dup', MacroWordSpec,
    ['"vm.push(vm.peek()); "'])

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
  @object_class.create_shared_method('over', MacroWordSpec,
    ['"vm.push(vm.peek(2)); "'])

  # [di,..d2,d1,i] pick [di,..d2,d1,di]
  @object_class.create_shared_method('pick', MacroWordSpec,
    ['"vm.push(vm.peek(vm.pop())); "'])

  # [b,a] nip [a]
  VirtualMachine.create_shared_method('nip', MacroWordSpec,
    ['"vm.swap_pop(); "'])

  # [b,a] tuck [a,b,a]
  VirtualMachine.create_shared_method('tuck', VmWordSpec, [],
    &lambda {|vm| vb,va = popm(2); push(va); push(vb); push(va); })


  #===================================================
  # Some stack arithmetic words.
  #===================================================

  # [b,a] + [b+a]
  @object_class.create_shared_method('+', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self + vm.pop()); })

  # [b,a] - [b-a]
  @object_class.create_shared_method('-', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self - vm.pop()); })

  # [b,a] * [b+a]
  @object_class.create_shared_method('*', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self * vm.pop()); })

  # [b,a] / [b-a]
  @object_class.create_shared_method('/', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self / vm.pop()); })

  # [b,a] mod [b-a]
  @object_class.create_shared_method('mod', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self % vm.pop()); })

  #===================================================
  # Some comparison words.
  #===================================================

  # [b,a] = if b == a then [true] else [false]
  @object_class.create_shared_method('=', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self == vm.pop()); })

  # [b,a] <> if b != a then [true] else [false]
  @object_class.create_shared_method('<>', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self != vm.pop()); })

  # [b,a] > if b > a then [true] else [false]
  @object_class.create_shared_method('>', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self > vm.pop()); })

  # [b,a] < if b < a then [true] else [false]
  @object_class.create_shared_method('<', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self < vm.pop()); })

  # [b,a] >= if b >= a then [true] else [false]
  @object_class.create_shared_method('>=', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self >= vm.pop()); })

  # [b,a] <= if b <= a then [true] else [false]
  @object_class.create_shared_method('<=', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self <= vm.pop()); })

  # [b,a] <=> if b <=> a then [true] else [false]
  @object_class.create_shared_method('<=>', DyadicWordSpec, [],
    &lambda {|vm| vm.push(self <=> vm.pop()); })

  #===================================================
  # Some comparison with zero words.
  #===================================================

  # [b,a] 0= if b == 0 then [true] else [false]
  @object_class.create_shared_method('0=', MethodWordSpec, [],
    &lambda {|vm| vm.push(self == 0); })

  # [b,a] 0<> if b != 0 then [true] else [false]
  @object_class.create_shared_method('0<>', MethodWordSpec, [],
    &lambda {|vm| vm.push(self != 0); })

  # [b,a] 0> if b > 0 then [true] else [false]
  @object_class.create_shared_method('0>', MethodWordSpec, [],
    &lambda {|vm| vm.push(self > 0); })

  # [b,a] 0< if b < 0 then [true] else [false]
  @object_class.create_shared_method('0<', MethodWordSpec, [],
    &lambda {|vm| vm.push(self < 0); })

  # [b,a] 0>= if b >= 0 then [true] else [false]
  @object_class.create_shared_method('0>=', MethodWordSpec, [],
    &lambda {|vm| vm.push(self >= 0); })

  # [b,a] 0<= if b <= 0 then [true] else [false]
  @object_class.create_shared_method('0<=', MethodWordSpec, [],
    &lambda {|vm| vm.push(self <= 0); })

  # [b,a] 0<=> if b <=> 0 then [true] else [false]
  @object_class.create_shared_method('0<=>', MethodWordSpec, [],
    &lambda {|vm| vm.push(self <=> 0); })

end
