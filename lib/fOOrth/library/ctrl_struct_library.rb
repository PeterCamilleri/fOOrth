# coding: utf-8

#* library/ctrl_struct_library.rb - The control structures fOOrth library.
module XfOOrth

  # [boolean] if (boolean true code) else (boolean false code) then
  VirtualMachine.create_shared_method('if', VmSpec, [:immediate], &lambda {|vm|
    suspend_execute_mode('if vm.pop? then ', :if)

    context.create_local_method('else', [:immediate], &lambda {|vm|
      check_deferred_mode('else ', [:if])
      vm.context.remove_local_method('else')
    })

    context.create_local_method('then', [:immediate],
      &lambda {|vm| resume_execute_mode('end; ', [:if]) })
  })

  # [unspecified] switch ... end [unspecified]
  VirtualMachine.create_shared_method('switch', VmSpec, [:immediate], &lambda {|vm|
    suspend_execute_mode('loop do; ', :switch)

    context.create_local_method('break', [:immediate],
      &lambda {|vm| vm << 'break; ' })

    context.create_local_method('?break', [:immediate],
      &lambda {|vm| vm << 'break if vm.pop?; ' })

    context.create_local_method('end', [:immediate],
      &lambda {|vm| resume_execute_mode('break; end; ', [:switch]) })
  })

  # Looping constructs for fOOrth.
  VirtualMachine.create_shared_method('begin', VmSpec, [:immediate], &lambda {|vm|
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
  VirtualMachine.create_shared_method('do', VmSpec, [:immediate], &lambda {|vm|
    jvar =  context[:jloop].to_s
    suspend_execute_mode("vm.vm_do(#{jvar}) {|iloop, jloop| ", :do)
    context[:jloop] = 'iloop'

    context.create_local_method('i', [:immediate],
      &lambda {|vm| vm <<  'vm.push(iloop[0]); ' })

    context.create_local_method('j', [:immediate],
      &lambda {|vm| vm << 'vm.push(jloop[0]); ' })

    context.create_local_method('-i', [:immediate],
      &lambda {|vm| vm << 'vm.push(iloop[2] - iloop[0]); ' })

    context.create_local_method('-j', [:immediate],
      &lambda {|vm| vm << 'vm.push(jloop[2] - jloop[0]); ' })

    context.create_local_method('loop', [:immediate],
      &lambda {|vm| resume_execute_mode('iloop[0] += 1}; ', [:do]) })

    context.create_local_method('+loop', [:immediate],
      &lambda {|vm| resume_execute_mode('iloop[0] += vm.vm_do_increment}; ', [:do]) })
  })

  #Support for the try ... catch ... finally ... end construct.
  VirtualMachine.create_shared_method('try', VmSpec, [:immediate], &lambda {|vm|
    suspend_execute_mode('begin; ', :try_block)

    SymbolMap.add_entry('error') #Make sure an entry for 'error' exists.
    SymbolMap.add_entry('?"')    #Make sure an entry for '?"' exists.

    context.create_local_method('catch', [:immediate], &lambda {|vm|
      check_deferred_mode('rescue StandardError, SignalException => error; ', [:try_block])

      vm.context.create_local_method('?"', [:immediate], &lambda {|vm|
        str = vm.pop
        vm << "vm.push(error.foorth_match(#{str.foorth_embed})); "
      })

      vm.context.create_local_method('error', [:immediate], &lambda {|vm|
        vm << 'vm.push(error.foorth_message); '
      })

      vm.context.create_local_method('bounce', [:immediate], &lambda {|vm|
        vm << 'raise; '
      })

      vm.context.remove_local_method('catch')
    })

    context.create_local_method('finally', [:immediate], &lambda {|vm|
      check_deferred_mode('ensure; ', [:try_block])

      vm.context.remove_local_method('catch')
      vm.context.remove_local_method('finally')
      vm.context.remove_local_method('?"')
      vm.context.remove_local_method('error')
      vm.context.remove_local_method('bounce')
    })

    vm.context.create_local_method('end', [:immediate], &lambda {|vm|
      vm.resume_execute_mode('end; ', [:try_block])
    })
  })

  #The object oriented .new{  } construct.
  #Note: Since this method is used to launch threads, the vm must be passed
  #explicitly to the lambda block. Otherwise, the new thread will use the
  #wrong vm instance. In other cases, this is harmless.
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
  VirtualMachine.create_shared_method('.select{', VmSpec, [:immediate], &lambda {|vm|
    suspend_execute_mode('vm.push(vm.pop.do_foorth_select{|vloop, xloop| ', :select_block)

    context.create_local_method('v', [:immediate],
      &lambda {|vm| vm << "vm.push(vloop); "} )

    context.create_local_method('x', [:immediate],
      &lambda {|vm| vm << "vm.push(xloop); "} )

    context.create_local_method('}', [:immediate],
      &lambda {|vm| vm.resume_execute_mode('vm.pop}); ', [:select_block]) })
  })

  #The object oriented .with{  } construct.
  VirtualMachine.create_shared_method('.with{', VmSpec, [:immediate], &lambda {|vm|
    old_mode = context[:mode]
    suspend_execute_mode('vm.pop.instance_exec(&lambda {', :with_block)

    if old_mode == :execute
      context[:obj] = vm.peek
    else
      context[:cls] = Object
    end

    context.create_local_method('}', [:immediate],
      &lambda {|vm| vm.resume_execute_mode('}); ', [:with_block]) })
  })

  #The object oriented .open{  } construct.
  VirtualMachine.create_shared_method('.open{', VmSpec, [:immediate], &lambda {|vm|

    suspend_execute_mode('vm.pop.do_foorth_open_block(vm){ ', :open_block)

    context.create_local_method('}', [:immediate],
      &lambda {|vm| vm.resume_execute_mode('}; ', [:open_block]) })
  })

  #The object oriented .create{  } construct.
  VirtualMachine.create_shared_method('.create{', VmSpec, [:immediate], &lambda {|vm|

    suspend_execute_mode('vm.pop.do_foorth_create_block(vm){ ', :create_block)

    context.create_local_method('}', [:immediate],
      &lambda {|vm| vm.resume_execute_mode('}; ', [:create_block]) })
  })

  #The object oriented .append{  } construct.
  VirtualMachine.create_shared_method('.append{', VmSpec, [:immediate], &lambda {|vm|

    suspend_execute_mode('vm.pop.do_foorth_append_block(vm){ ', :append_block)

    context.create_local_method('}', [:immediate],
      &lambda {|vm| vm.resume_execute_mode('}; ', [:append_block]) })
  })

end
