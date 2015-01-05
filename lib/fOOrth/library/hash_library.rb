# coding: utf-8

#* library/hash_library.rb - Hash support for the fOOrth library.
module XfOOrth

  #Connect the Array class to the fOOrth class system.
  Hash.create_foorth_proxy

  # [] Hash .new [{}]; create an empty hash.
  # The default implementation from Object is used for this.

  # [] { k1 v1 -> ... kn vn -> } [{k1=>v1,...kn=>vn}]; a hash literal value
  VirtualMachine.create_shared_method('{', VmSpec, [:immediate], &lambda { |vm|
    vm.suspend_execute_mode('vm.push(Hash.new); ', :hash_literal)

    vm.context.create_local_method('->', [:immediate],
      &lambda {|vm| vm << 'vm.add_to_hash; ' })

    vm.context.create_local_method('}', [:immediate],
      &lambda {|vm| vm.resume_execute_mode('', [:hash_literal]) })
  })

end