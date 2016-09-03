# coding: utf-8

#* library/stubs.rb - The standard fOOrth library.
module XfOOrth

  # Some comparison words.  See numeric_library.rb and string_library.rb
  Object.create_shared_method('>',      NosSpec, [:stub])
  Object.create_shared_method('<',      NosSpec, [:stub])
  Object.create_shared_method('>=',     NosSpec, [:stub])
  Object.create_shared_method('<=',     NosSpec, [:stub])
  Object.create_shared_method('<=>',    NosSpec, [:stub])

  # Some comparison with zero words.  See numeric_library.rb
  Object.create_shared_method('0=',     TosSpec, [:stub])
  Object.create_shared_method('0<>',    TosSpec, [:stub])
  Object.create_shared_method('0>',     TosSpec, [:stub])
  Object.create_shared_method('0<',     TosSpec, [:stub])
  Object.create_shared_method('0>=',    TosSpec, [:stub])
  Object.create_shared_method('0<=',    TosSpec, [:stub])
  Object.create_shared_method('0<=>',   TosSpec, [:stub])

  # Stubs for the stack arithmetic words. See numeric_library.rb
  Object.create_shared_method('+',      NosSpec, [:stub])
  Object.create_shared_method('-',      NosSpec, [:stub])
  Object.create_shared_method('*',      NosSpec, [:stub])
  Object.create_shared_method('**',     NosSpec, [:stub])
  Object.create_shared_method('/',      NosSpec, [:stub])
  Object.create_shared_method('mod',    NosSpec, [:stub])
  Object.create_shared_method('neg',    TosSpec, [:stub])

  Object.create_shared_method('1+',     TosSpec, [:stub])
  Object.create_shared_method('1-',     TosSpec, [:stub])
  Object.create_shared_method('2+',     TosSpec, [:stub])
  Object.create_shared_method('2-',     TosSpec, [:stub])
  Object.create_shared_method('2*',     TosSpec, [:stub])
  Object.create_shared_method('2/',     TosSpec, [:stub])

  Object.create_shared_method(')stubs', TosSpec, [:stub])

  # Some bitwise operation stubs. See numeric_library.rb
  Object.create_shared_method('and',    NosSpec, [:stub])
  Object.create_shared_method('or',     NosSpec, [:stub])
  Object.create_shared_method('xor',    NosSpec, [:stub])
  Object.create_shared_method('com',    TosSpec, [:stub])
  Object.create_shared_method('<<',     NosSpec, [:stub])
  Object.create_shared_method('>>',     NosSpec, [:stub])

  Object.create_shared_method('@',      TosSpec, [:stub])
  Object.create_shared_method('!',      TosSpec, [:stub])

  Object.create_shared_method('parse',  NosSpec, [:stub])
  Object.create_shared_method('parse!', NosSpec, [:stub])
  Object.create_shared_method('p"',     NosSpec, [:stub])
  Object.create_shared_method('p!"',    NosSpec, [:stub])

  #Procedure literal stubs.
  Object.create_shared_method('.each{{',        NosSpec, [:stub])
  Object.create_shared_method('.new{{',         NosSpec, [:stub])
  Object.create_shared_method('.map{{',         NosSpec, [:stub])
  Object.create_shared_method('.select{{',      NosSpec, [:stub])
  Object.create_shared_method('.open{{',        NosSpec, [:stub])
  Object.create_shared_method('.create{{',      NosSpec, [:stub])
  Object.create_shared_method('.append{{',      NosSpec, [:stub])
  Object.create_shared_method('.do{{',          NosSpec, [:stub])
  Object.create_shared_method('.default{{',     NosSpec, [:stub])
  Object.create_shared_method('.new_default{{', NosSpec, [:stub])

  #Embedding stubs.
  Object.create_shared_method(',asm',   TosSpec, [:stub])
  Object.create_shared_method(',asm"',  TosSpec, [:stub])

  #Define some "crossover" symbols.
  SymbolMap.add_entry('.is_class?',     :foorth_is_class?)
  SymbolMap.add_entry('.to_s',          :to_foorth_s)
  SymbolMap.add_entry('.strlen',        :foorth_strlen)
  SymbolMap.add_entry('.strmax',        :foorth_strmax)
  SymbolMap.add_entry('.strmax2',       :foorth_strmax2)
  SymbolMap.add_entry('.pp',            :foorth_columns)
  SymbolMap.add_entry('.print_bullets', :foorth_bullets)
  SymbolMap.add_entry('.load',          :foorth_load_file)
  SymbolMap.add_entry('.method_info',   :foorth_method_info)
end
