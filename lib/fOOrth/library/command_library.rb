# coding: utf-8

#* library/command_library.rb - The utility command fOOrth library.
module XfOOrth

  #The quit out of fOOrth method.
  Object.create_shared_method(')quit', MacroSpec,
    [:macro, "raise ForceExit; "])

  #Execute a command to the shell.
  Object.create_shared_method(')"', MacroSpec,
    [:macro, "system(vm.pop()); "])

  #Enter debug mode. Warning! This is really verbose!
  Object.create_shared_method(')debug', MacroSpec,
    [:macro, "vm.debug = true; "])

  #Display the current fOOrth language version.
  Object.create_shared_method(')version', MacroSpec,
    [:macro, "puts XfOOrth::VERSION; "])

end
