# coding: utf-8

#* library/ctrl_struct_library.rb - The control structures fOOrth library.
module XfOOrth

  # [boolean] if (boolean true code) else (boolean false code) then
  VirtualMachine.create_shared_method('if', VmWordSpec, [:immediate],
    &lambda {|vm|
      suspend_execute_mode('if vm.pop? then ', :if)

      context.create_local_method('else', [:immediate],
        &lambda {|vm| check_deferred_mode('else ', [:if]) })

      context.create_local_method('then', [:immediate],
        &lambda {|vm| resume_execute_mode('end; ', [:if]) })
    })

  # Looping constructs for fOOrth.
  VirtualMachine.create_shared_method('begin', VmWordSpec, [:immediate],
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

  # Support for the classic do loop constructs!
  #
  # NOTE: The do loop must always be configured to count upward. This is due
  # the the end condition being count > limit instead of count == limit. To
  # count backward use -i or -j to access the reverse count. This change from
  # the classic FORTH version is to avoid its tendency to loop forever.
  VirtualMachine.create_shared_method('do', VmWordSpec, [:immediate],
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

end
