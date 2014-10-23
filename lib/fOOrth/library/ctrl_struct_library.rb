# coding: utf-8

#* library/ctrl_struct_library.rb - The control structures fOOrth library.
module XfOOrth

  #===================================================
  # Support for the classic if else then construct!
  #===================================================

  # [boolean] if (boolean true code) else (boolean false code) then

  VirtualMachine.create_shared_method('if', VmWordSpec, [:immediate],
    &lambda {|vm| suspend_execute_mode('if vm.pop? then ', :if) })

  VirtualMachine.create_shared_method('else', VmWordSpec, [:immediate],
    &lambda {|vm| check_deferred_mode('else ', [:if]) })

  VirtualMachine.create_shared_method('then', VmWordSpec, [:immediate],
    &lambda {|vm| resume_execute_mode('end; ', [:if]) })


  #===================================================
  # Support for the classic begin until constructs!
  #===================================================

  VirtualMachine.create_shared_method('begin', VmWordSpec, [:immediate],
    &lambda {|vm| suspend_execute_mode('begin ', :begin) })

  VirtualMachine.create_shared_method('while', VmWordSpec, [:immediate],
    &lambda {|vm| check_deferred_mode('break unless pop?; ', [:begin]) })

  VirtualMachine.create_shared_method('until', VmWordSpec, [:immediate],
    &lambda {|vm| resume_execute_mode('end until vm.pop?; ', [:begin]) })

  VirtualMachine.create_shared_method('again', VmWordSpec, [:immediate],
    &lambda {|vm| resume_execute_mode('end until false; ', [:begin]) })

  VirtualMachine.create_shared_method('repeat', VmWordSpec, [:immediate],
    &lambda {|vm| resume_execute_mode('end until false; ', [:begin]) })


  #===================================================
  # Support for the classic do loop constructs!
  #
  # NOTE: The do loop must always be configured to
  # count upward. To count backward use -i or -j to
  # access the reverse count. This differs from the
  # classic FORTH version to avoid its tendency to
  # fly off into endless loops.
  #===================================================

  VirtualMachine.create_shared_method('do', VmWordSpec, [:immediate],
    &lambda {|vm|
      jvar =  context[:jloop].to_s
      suspend_execute_mode("vm.vm_do(#{jvar}) {|iloop, jloop| ", :do)
      context[:jloop] = 'iloop'
    })

  VirtualMachine.create_shared_method('i', VmWordSpec, [:immediate],
    &lambda {|vm| check_deferred_mode('vm.push(iloop[0]); ', [:do]) })

  VirtualMachine.create_shared_method('j', VmWordSpec, [:immediate],
    &lambda {|vm| check_deferred_mode('vm.push(jloop[0]); ', [:do]) })

  VirtualMachine.create_shared_method('-i', VmWordSpec, [:immediate],
    &lambda {|vm| check_deferred_mode('vm.push(iloop[2] - iloop[0]); ', [:do]) })

  VirtualMachine.create_shared_method('-j', VmWordSpec, [:immediate],
    &lambda {|vm| check_deferred_mode('vm.push(jloop[2] - jloop[0]); ', [:do]) })

  VirtualMachine.create_shared_method('loop', VmWordSpec, [:immediate],
    &lambda {|vm| resume_execute_mode('iloop[0] += 1}; ', [:do]) })

  VirtualMachine.create_shared_method('+loop', VmWordSpec, [:immediate],
    &lambda {|vm| resume_execute_mode('iloop[0] += vm.pop}; ', [:do]) })

end
