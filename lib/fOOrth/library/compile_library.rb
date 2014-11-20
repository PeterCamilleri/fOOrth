# coding: utf-8

#* library/compile_library.rb - The compile support fOOrth library.
module XfOOrth

  #The classic colon definition that creates a word in the Virtual Machine class.
  VirtualMachine.create_shared_method(':', VmSpec, [],  &lambda {|vm|
    target = VirtualMachine
    name   = vm.parser.get_word()
    type   = VmSpec

    begin_compile_mode(':', vm: vm, &lambda {|vm, src|
      puts "#{name} => #{src}" if vm.debug
      target.create_shared_method(name, type, [], &eval(src))
    })
  })

  #An array of types allowed for a method.
  AllowedMethodTypes = [TosSpec,
                        SelfSpec,
                        TosSpec,
                        DyadicWordSpec]

  #Determine the type of word being created.
  def self.name_to_type(name)
    case name[0]
    when '.'
      TosSpec

    when '~'
      SelfSpec

    else
      type = (spec = object_maps_name(name)) && spec.does
      type = nil unless AllowedMethodTypes.include?(type)
      error "Invalid name for a method: #{name}" unless type
      type
    end
  end

  #A colon definition that creates a word in the specified class.
  compile_action = lambda {|vm|
    target = self
    name   = vm.parser.get_word()
    type   = XfOOrth.name_to_type(name)

    vm.begin_compile_mode('x::', cls: target, &lambda {|vm, src|
      puts "#{target.name} #{name} => #{src}" if vm.debug
      target.create_shared_method(name, type, [], &eval(src))
    })
  }

  Class.create_shared_method('.::', TosSpec, [],  &compile_action)

  #The standard end-compile adapter word: ';' semi-colon.
  VirtualMachine.create_shared_method(';', VmSpec, [:immediate],
    &lambda {|vm| end_compile_mode([':', 'x::']) })

  #The immediate end-compile adapter word: ;immediate.
  VirtualMachine.create_shared_method(';immediate', VmSpec, [:immediate],
    &lambda {|vm| end_compile_mode([':', 'x::']).tags << :immediate })

end