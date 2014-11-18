# coding: utf-8

#* library/command_library.rb - The utility command fOOrth library.
module XfOOrth

  #The quit out of fOOrth method.
  Object.create_shared_method(')quit', MacroWordSpec,
    ["raise ForceExit; "])

  #Execute a command to the shell.
  Object.create_shared_method(')"', MacroWordSpec,
    ["system(vm.pop()); "])

  #Execute a command to the shell.
  Object.create_shared_method(')debug', MacroWordSpec,
    ["vm.debug = true; "])


end
