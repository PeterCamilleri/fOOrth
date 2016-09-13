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

  #Investigate a method of this class.
  def foorth_method_info(name)
    symbol, results = XfOOrth::SymbolMap.map_info(name)
    found = false

    if symbol
      spec, info = map_foorth_shared_info(symbol)

      if spec && !spec.has_tag?(:stub)
        (results << ["", ""]).concat(info).concat(spec.get_info)
        found = true
      end

      spec, info = map_foorth_exclusive_info(symbol)

      if spec && !spec.has_tag?(:stub)
        (results << ["", ""]).concat(info).concat(spec.get_info)
        found = true
      end

      results << ["Scope", "not found."] unless found
    end

    results
  end

  #Get introspection info.
  def get_info
    results = [["Lineage", lineage]]

    if foorth_has_exclusive?
      results.concat([["", ""], ["Methods", "Class"]])

      foorth_exclusive.extract_method_names(:all).sort.each do |name|
        symbol, info = XfOOrth::SymbolMap.map_info(name)
        (results << ["", ""]).concat(info)

        spec, info = map_foorth_exclusive_info(symbol, :shallow)
        results.concat(info).concat(spec.get_info)
      end
    end

    unless foorth_shared.empty?
      results.concat([["", ""], ["Methods", "Shared"]])

      foorth_shared.extract_method_names(:all).sort.each do |name|
        symbol, info = XfOOrth::SymbolMap.map_info(name)
        (results << ["", ""]).concat(info)

        spec, info = map_foorth_shared_info(symbol, :shallow)
        results.concat(info).concat(spec.get_info)
      end
    end

    results
  end

end
