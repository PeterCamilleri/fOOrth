# coding: utf-8

#* library/stubs.rb - The standard fOOrth library.
module XfOOrth

  # Stubs for the stack arithmetic words. See numeric_library.rb
  Object.create_shared_method('+',   NosSpec, [:stub])
  Object.create_shared_method('-',   NosSpec, [:stub])
  Object.create_shared_method('*',   NosSpec, [:stub])
  Object.create_shared_method('**',  NosSpec, [:stub])
  Object.create_shared_method('/',   NosSpec, [:stub])
  Object.create_shared_method('mod', NosSpec, [:stub])
  Object.create_shared_method('neg', TosSpec, [:stub])

  # Some bitwise operation stubs. See numeric_library.rb
  Object.create_shared_method('and', TosSpec, [:stub])
  Object.create_shared_method('or',  TosSpec, [:stub])
  Object.create_shared_method('xor', TosSpec, [:stub])
  Object.create_shared_method('com', TosSpec, [:stub])
  Object.create_shared_method('<<',  NosSpec, [:stub])
  Object.create_shared_method('>>',  NosSpec, [:stub])

end
