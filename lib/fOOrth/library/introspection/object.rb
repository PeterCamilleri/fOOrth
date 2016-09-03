# coding: utf-8

#* library/introspection/object.rb - Object support for introspection.
class Object

  #Map the symbol to a specification or nil if there is no mapping.
  def map_foorth_exclusive_info(symbol, shallow=nil)
    if (foorth_has_exclusive? && (spec = foorth_exclusive[symbol]))
      [spec, [["Object", foorth_name], ["Scope", "Exclusive"]]]
    elsif !shallow
      self.class.map_foorth_shared_info(symbol)
    else
      [nil, nil]
    end
  end

end
