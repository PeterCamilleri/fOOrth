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

  #Get the lineage of this class.
  def lineage
    #Ugly hack, sorry!
    if [Object, Module].include?(self)
      "Object"
    else
      foorth_class_name + " < " + superclass.lineage
    end
  end

end
