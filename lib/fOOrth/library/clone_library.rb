# coding: utf-8

#* library/clone_library.rb - The fOOrth data cloning library.
module XfOOrth

  #Add an explicit mapping for .clone_exclude so that it is accessible to Ruby.
  SymbolMap.add_entry('.clone_exclude', :foorth_exclude)

  # [a] copy [a, a']
  VirtualMachine.create_shared_method('copy', MacroSpec,
    [:macro, "vm.push(vm.peek.safe_clone); "])

  # [a] .copy [a']
  Object.create_shared_method('.copy', TosSpec, [],
    &lambda {|vm| vm.push(self.safe_clone); })

  # [a] clone [a, a']
  VirtualMachine.create_shared_method('clone', MacroSpec,
    [:macro, "vm.push(vm.peek.full_clone); "])

  # [a] .clone [a']
  Object.create_shared_method('.clone', TosSpec, [],
    &lambda {|vm| vm.push(self.full_clone); })

  # [] .clone_exclude [[exclusion_list]]
  Object.create_shared_method('.clone_exclude', TosSpec, [],
    &lambda {|vm| vm.push([]); })

end

#* Runtime clone library support in Object.
class Object

  # The full clone data member clone exclusion control
  def full_clone_exclude
    vm = Thread.current[:vm]
    self.foorth_exclude(vm)

    vm.pop.map do |entry|
      if (sym = XfOOrth::SymbolMap.map(entry))
        ("@" + sym.to_s).to_sym
      else
        entry
      end
    end
  end

end

#* Runtime clone library support in Array.
class Array

  # The full clone data member clone exclusion control
  def full_clone_exclude
    vm = Thread.current[:vm]
    self.foorth_exclude(vm)
    vm.pop
  end

end

#* Runtime clone library support in Hash.
class Hash

  # The full clone data member clone exclusion control
  def full_clone_exclude
    vm = Thread.current[:vm]
    self.foorth_exclude(vm)
    vm.pop
  end

end
