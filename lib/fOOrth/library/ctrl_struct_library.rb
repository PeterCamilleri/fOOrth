# coding: utf-8

#* library/ctrl_struct_library.rb - The control structures fOOrth library.
module XfOOrth

  # [boolean] if (boolean true code) else (boolean false code) then
  VirtualMachine.create_shared_method('if', VmSpec, [:immediate], &lambda {|vm|
    suspend_execute_mode('if vm.pop? then ', :if)

    context.create_local_method('else', LocalSpec, [:immediate], &lambda {|vm|
      vm.check_deferred_mode('else ', [:if])
      vm.context.remove_local_method('else')
    })

    context.create_local_method('then', LocalSpec, [:immediate],
      &lambda {|vm| vm.resume_execute_mode('end; ', [:if]) })
  })

  # [unspecified] switch ... end [unspecified]
  VirtualMachine.create_shared_method('switch', VmSpec, [:immediate], &lambda {|vm|
    suspend_execute_mode('loop do; ', :switch)

    context.create_local_method('break', LocalSpec, [:immediate],
      &lambda {|vm| vm << 'break; ' })

    context.create_local_method('?break', LocalSpec, [:immediate],
      &lambda {|vm| vm << 'break if vm.pop?; ' })

    context.create_local_method('end', LocalSpec, [:immediate],
      &lambda {|vm| vm.resume_execute_mode('break; end; ', [:switch]) })
  })

  # Looping constructs for fOOrth.
  VirtualMachine.create_shared_method('begin', VmSpec, [:immediate], &lambda {|vm|
    suspend_execute_mode('begin ', :begin)

    context.create_local_method('while', LocalSpec, [:immediate],
      &lambda {|vm| vm.check_deferred_mode('break unless vm.pop?; ', [:begin]) })

    context.create_local_method('until', LocalSpec, [:immediate],
      &lambda {|vm| vm.resume_execute_mode('end until vm.pop?; ', [:begin]) })

    context.create_local_method('again', LocalSpec, [:immediate],
      &lambda {|vm| vm.resume_execute_mode('end until false; ', [:begin]) })

    context.create_local_method('repeat', LocalSpec, [:immediate],
      &lambda {|vm| vm.resume_execute_mode('end until false; ', [:begin]) })
  })

  # Support for the sanitized do loop constructs!
  VirtualMachine.create_shared_method('do', VmSpec, [:immediate], &lambda {|vm|
    jvar =  context[:jloop].to_s
    suspend_execute_mode("vm.vm_do(#{jvar}) {|iloop, jloop| ", :do)
    context[:jloop] = 'iloop'

    context.create_local_method('i', MacroSpec,
      [:macro, 'vm.push(iloop[0]); '])

    context.create_local_method('j', MacroSpec,
      [:macro, 'vm.push(jloop[0]); '])

    context.create_local_method('-i', MacroSpec,
      [:macro, 'vm.push(iloop[2] - iloop[0]); '])

    context.create_local_method('-j', MacroSpec,
      [:macro, 'vm.push(jloop[2] - jloop[0]); '])

    context.create_local_method('loop', LocalSpec, [:immediate],
      &lambda {|vm| vm.resume_execute_mode('iloop[0] += 1}; ', [:do]) })

    context.create_local_method('+loop', LocalSpec, [:immediate],
      &lambda {|vm| vm.resume_execute_mode('iloop[0] += vm.vm_do_increment}; ', [:do]) })
  })

  #Support for the try ... catch ... finally ... end construct.
  VirtualMachine.create_shared_method('try', VmSpec, [:immediate], &lambda {|vm|
    suspend_execute_mode('begin; ', :try_block)

    SymbolMap.add_entry('error') #Make sure an entry for 'error' exists.
    SymbolMap.add_entry('?"')    #Make sure an entry for '?"' exists.

    context.create_local_method('catch', LocalSpec, [:immediate], &lambda {|vm|
      check_deferred_mode('rescue StandardError, SignalException => error; ', [:try_block])

      vm.context.create_local_method('?"', LocalSpec, [:immediate], &lambda {|vm|
        str = vm.pop
        vm << "vm.push(error.foorth_match(#{str.foorth_embed})); "
      })

      vm.context.create_local_method('error', LocalSpec, [:immediate], &lambda {|vm|
        vm << 'vm.push(error.foorth_message); '
      })

      vm.context.create_local_method('bounce', LocalSpec, [:immediate], &lambda {|vm|
        vm << 'raise; '
      })

      vm.context.remove_local_method('catch')
    })

    context.create_local_method('finally', LocalSpec, [:immediate], &lambda {|vm|
      vm.check_deferred_mode('ensure; ', [:try_block])

      vm.context.remove_local_method('catch')
      vm.context.remove_local_method('finally')
      vm.context.remove_local_method('?"')
      vm.context.remove_local_method('error')
      vm.context.remove_local_method('bounce')
    })

    vm.context.create_local_method('end', LocalSpec, [:immediate], &lambda {|vm|
      vm.resume_execute_mode('end; ', [:try_block])
    })
  })

  #Support for the [[ ... ]] construct.
  VirtualMachine.create_shared_method('[[', VmSpec, [:immediate], &lambda {|vm|
    suspend_buffered_mode('[[')

    vm.context.create_local_method(']]', LocalSpec, [:immediate], &lambda {|vm|
      vm.resume_buffered_mode('[[')
    })
  })

  #Support for the , method. Embed a value into the code stream.
  Object.create_shared_method(',', TosSpec, [], &lambda {|vm|
    vm << "vm.push(#{foorth_embed}); "
  })

  #Support for the asm" method. Perform some actions in assembly language.
  #[] asm"asm_string" []
  VirtualMachine.create_shared_method('asm"', VmSpec, [:immediate], &lambda {|vm|
    code = vm.pop

    if execute_mode?
      vm.instance_exec(self, &eval("lambda {|vm| #{code} }"))
    else
      vm << code
    end
  })

  #Support for the .asm method. Perform some actions in assembly language.
  #[asm_string] .asm []
  String.create_shared_method('.asm', TosSpec, [], &lambda {|vm|
    vm.instance_exec(vm, &eval("lambda {|vm| #{self} }"))
  })

  #Support for the ,asm" method. Embed some actions in assembly language.
  #[] ,asm"asm_string" []
  String.create_shared_method(',asm"', TosSpec, [], &lambda {|vm|
    vm << self
  })

  #Support for the ,asm method. Embed some actions in assembly language.
  #[asm_string] ,asm []
  String.create_shared_method(',asm', TosSpec, [], &lambda {|vm|
    vm << self
  })

end
