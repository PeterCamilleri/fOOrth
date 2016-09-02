# coding: utf-8

#* library/introspection/object.rb - Object support for introspection.
class Object

  #Map the symbol to a specification or nil if there is no mapping.
  def map_foorth_exclusive_info(symbol)
    if (foorth_has_exclusive? && (spec = foorth_exclusive[symbol]))
      [spec, [["Scope", "Exclusive"], ["Object", foorth_name]]]
    else
      self.class.map_foorth_shared_info(symbol)
    end
  end

end
