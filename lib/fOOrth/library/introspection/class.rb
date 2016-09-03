# coding: utf-8

#* library/introspection/class.rb - Class support for introspection.
class Class

  #Get information about the mapping of the symbol.
  def map_foorth_shared_info(symbol, shallow=nil)
    if (spec = foorth_shared[symbol])
      [spec, [["Class", foorth_class_name], ["Scope", "Shared"]]]
    elsif (sc = superclass) && !shallow
      sc.map_foorth_shared_info(symbol)
    else
      [nil, nil]
    end
  end

end

