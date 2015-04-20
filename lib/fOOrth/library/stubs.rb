# coding: utf-8

#* library/stubs.rb - The standard fOOrth library.
module XfOOrth

  # Some comparison words.  See numeric_library.rb and string_library.rb
  Object.create_shared_method('>',    NosSpec, [:stub])
  Object.create_shared_method('<',    NosSpec, [:stub])
  Object.create_shared_method('>=',   NosSpec, [:stub])
  Object.create_shared_method('<=',   NosSpec, [:stub])
  Object.create_shared_method('<=>',  NosSpec, [:stub])

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

  #Define some "crossover" symbols.
 #SymbolMap.add_entry('.init',          :foorth_new) -- aliased in core.rb
  SymbolMap.add_entry('.is_class?',     :foorth_is_class?)
  SymbolMap.add_entry('.to_s',          :to_foorth_s)
  SymbolMap.add_entry('.strlen',        :foorth_strlen)
  SymbolMap.add_entry('.strmax',        :foorth_strmax)
  SymbolMap.add_entry('.strmax2',       :foorth_strmax2)
  SymbolMap.add_entry('.pp',            :foorth_pretty)
  SymbolMap.add_entry('.load',          :foorth_load_file)
end

#* Runtime library support stubs.
class Object
  # Runtime stub for the .new{ } construct.
  def do_foorth_new_block(_vm, &block)
    error "F12: A #{self.foorth_name} does not support .new{ ... }."
  end

  # Runtime stub for the .each{ } construct.
  def do_foorth_each(&block)
    error "F12: A #{self.foorth_name} does not support .each{ ... }."
  end

  # Runtime stub for the .map{ } construct.
  def do_foorth_map(&block)
    error "F12: A #{self.foorth_name} does not support .map{ ... }."
  end

  # Runtime stub for the .select{ } construct.
  def do_foorth_select(&block)
    error "F12: A #{self.foorth_name} does not support .select{ ... }."
  end

  # Runtime stub for the .open{ } construct.
  def do_foorth_open_block(_vm, &block)
    error "F12: A #{self.foorth_name} does not support .open{ ... }."
  end

  # Runtime stub for the .create{ } construct.
  def do_foorth_create_block(_vm, &block)
    error "F12: A #{self.foorth_name} does not support .create{ ... }."
  end

  # Runtime stub for the .append{ } construct.
  def do_foorth_append_block(_vm, &block)
    error "F12: A #{self.foorth_name} does not support .append{ ... }."
  end

  # Runtime stub for >
  def mnmx_gt(_other)
    error "F12: A #{self.foorth_name} does not support >."
  end

  # Runtime stub for <
  def mnmx_lt(_other)
    error "F12: A #{self.foorth_name} does not support <."
  end

  # Runtime stub for >=
  def mnmx_ge(_other)
    error "F12: A #{self.foorth_name} does not support >=."
  end

  # Runtime stub for <=
  def mnmx_le(_other)
    error "F12: A #{self.foorth_name} does not support <=."
  end

  # Runtime stub for <=>
  def mnmx_cp(_other)
    error "F12: A #{self.foorth_name} does not support <=>."
  end

end
