# coding: utf-8

#* library/introspection/class.rb - Class support for introspection.
class Class

  #Get information about the mapping of the symbol.
  def map_foorth_shared_info(symbol)
    if (spec = foorth_shared[symbol])
      [spec, [["Scope", "Shared"], ["Class", foorth_class_name]]]
    elsif (sc = superclass)
      sc.map_foorth_shared_info(symbol)
    else
      [nil, nil]
    end
  end

end

