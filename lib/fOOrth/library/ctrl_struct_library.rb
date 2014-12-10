# coding: utf-8

#* library/ctrl_struct_library.rb - The control structures fOOrth library.
module XfOOrth

  # [boolean] if (boolean true code) else (boolean false code) then
  VirtualMachine.create_shared_method('if', VmSpec, [:immediate],
    &lambda {|vm|
      suspend_execute_mode('if vm.pop? then ', :if)

      context.create_local_method('else', [:immediate],
        &lambda {|vm| check_deferred_mode('else ', [:if]) })

      context.create_local_method('then', [:immediate],
        &lambda {|vm| resume_execute_mode('end; ', [:if]) })
    })

  # Looping constructs for fOOrth.
  VirtualMachine.create_shared_method('begin', VmSpec, [:immediate],
    &lambda {|vm|
      suspend_execute_mode('begin ', :begin)

      context.create_local_method('while', [:immediate],
        &lambda {|vm| check_deferred_mode('break unless vm.pop?; ', [:begin]) })

      context.create_local_method('until', [:immediate],
        &lambda {|vm| resume_execute_mode('end until vm.pop?; ', [:begin]) })

      context.create_local_method('again', [:immediate],
        &lambda {|vm| resume_execute_mode('end until false; ', [:begin]) })

      context.create_local_method('repeat', [:immediate],
        &lambda {|vm| resume_execute_mode('end until false; ', [:begin]) })
    })

  # Support for the sanitized do loop constructs!
  VirtualMachine.create_shared_method('do', VmSpec, [:immediate],
    &lambda {|vm|
      jvar =  context[:jloop].to_s
      suspend_execute_mode("vm.vm_do(#{jvar}) {|iloop, jloop| ", :do)
      context[:jloop] = 'iloop'

      context.create_local_method('i', [:immediate],
        &lambda {|vm| check_deferred_mode('vm.push(iloop[0]); ', [:do]) })

      context.create_local_method('j', [:immediate],
        &lambda {|vm| check_deferred_mode('vm.push(jloop[0]); ', [:do]) })

      context.create_local_method('-i', [:immediate],
        &lambda {|vm| check_deferred_mode('vm.push(iloop[2] - iloop[0]); ', [:do]) })

      context.create_local_method('-j', [:immediate],
        &lambda {|vm| check_deferred_mode('vm.push(jloop[2] - jloop[0]); ', [:do]) })

      context.create_local_method('loop', [:immediate],
        &lambda {|vm| resume_execute_mode('iloop[0] += 1}; ', [:do]) })

      context.create_local_method('+loop', [:immediate],
        &lambda {|vm| resume_execute_mode('iloop[0] += vm.pop}; ', [:do]) })
    })

  #The object oriented .new{  } construct.
  VirtualMachine.create_shared_method('.new{', VmSpec, [:immediate], &lambda { |vm|
    vm.suspend_execute_mode('vm.push(vm.pop.do_foorth_new_block(vm) {|vm, xloop| ', :new_block)

    vm.context.create_local_method('x', [:immediate],
      &lambda {|vm| vm << "vm.push(xloop); "} )

    vm.context.create_local_method('}', [:immediate],
      &lambda {|vm| vm.resume_execute_mode('vm.data_stack.pop}); ', [:new_block]) })
  })

  #The object oriented .each{  } construct.
  VirtualMachine.create_shared_method('.each{', VmSpec, [:immediate], &lambda { |vm|
    suspend_execute_mode('vm.pop.do_foorth_each{|vloop, xloop| ', :each_block)

    context.create_local_method('v', [:immediate],
      &lambda {|vm| vm << "vm.push(vloop); "} )

    context.create_local_method('x', [:immediate],
      &lambda {|vm| vm << "vm.push(xloop); "} )

    context.create_local_method('}', [:immediate],
      &lambda {|vm| vm.resume_execute_mode('}; ', [:each_block]) })
  })

  #The object oriented .map{  } construct.
  VirtualMachine.create_shared_method('.map{', VmSpec, [:immediate], &lambda { |vm|
    suspend_execute_mode('vm.push(vm.pop.do_foorth_map{|vloop, xloop| ', :map_block)

    context.create_local_method('v', [:immediate],
      &lambda {|vm| vm << "vm.push(vloop); "} )

    context.create_local_method('x', [:immediate],
      &lambda {|vm| vm << "vm.push(xloop); "} )

    context.create_local_method('}', [:immediate],
      &lambda {|vm| vm.resume_execute_mode('vm.pop}); ', [:map_block]) })
  })

  #The object oriented .select{  } construct.
  VirtualMachine.create_shared_method('.select{', VmSpec, [:immediate], &lambda { |vm|
    suspend_execute_mode('vm.push(vm.pop.do_foorth_select{|vloop, xloop| ', :select_block)

    context.create_local_method('v', [:immediate],
      &lambda {|vm| vm << "vm.push(vloop); "} )

    context.create_local_method('x', [:immediate],
      &lambda {|vm| vm << "vm.push(xloop); "} )

    context.create_local_method('}', [:immediate],
      &lambda {|vm| vm.resume_execute_mode('vm.pop}); ', [:select_block]) })
  })

end
