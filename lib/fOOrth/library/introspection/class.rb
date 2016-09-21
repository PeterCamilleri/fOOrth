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
      if scrape_method_info(results, *map_foorth_shared_info(symbol))
        found = true
      end

      if scrape_method_info(results, *map_foorth_exclusive_info(symbol))
        found = true
      end

      results << ["Scope", "not found."] unless found
    end

    results
  end

  #Get introspection info.
  def get_info
    results = [["Lineage", lineage]]

    get_exclusive_method_info(results)
    get_shared_method_info(results)

    results
  end

  private

  #Get method information
  #<br>Endemic Code Smells
  #* :reek:UtilityFunction
  def scrape_method_info(results, spec, info)
    if spec && !spec.has_tag?(:stub)
      (results << ["", ""]).concat(info).concat(spec.get_info)
      true
    else
      false
    end
  end

  #Get shared method info
  def get_shared_method_info(results)
    unless foorth_shared.empty?
      results.concat([["", ""], ["Methods", "Shared"]])

      foorth_shared.extract_method_names(:all).sort.each do |name|
        symbol, info = XfOOrth::SymbolMap.map_info(name)
        (results << ["", ""]).concat(info)

        spec, info = map_foorth_shared_info(symbol, :shallow)
        results.concat(info).concat(spec.get_info)
      end
    end
  end

  #Get exclusive method info
  def get_exclusive_method_info(results)
    if foorth_has_exclusive?
      results.concat([["", ""], ["Methods", "Class"]])

      foorth_exclusive.extract_method_names(:all).sort.each do |name|
        symbol, info = XfOOrth::SymbolMap.map_info(name)
        (results << ["", ""]).concat(info)

        spec, info = map_foorth_exclusive_info(symbol, :shallow)
        results.concat(info).concat(spec.get_info)
      end
    end
  end

end
