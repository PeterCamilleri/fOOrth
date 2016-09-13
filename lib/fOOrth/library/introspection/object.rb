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

  #Get introspection info.
  def get_info
    results = [["Type", foorth_name]]

    unless (vars = instance_variables).empty?
      results.concat([["", ""], ["Data", "Instance"], ["", ""]])

      vars.sort.each do |name|
        var_name = XfOOrth::SymbolMap.unmap(name[1..-1].to_sym) || name
        results << [var_name, instance_variable_get(name)]
      end
    end

    if foorth_has_exclusive?
      results.concat([["", ""], ["Methods", "Exclusive"]])

      foorth_exclusive.extract_method_names(:all).sort.each do |name|
        symbol, info = XfOOrth::SymbolMap.map_info(name)
        results.concat([["", ""], ["Name", name], info])
        spec, info = map_foorth_exclusive_info(symbol, :shallow)
        results.concat(info).concat(spec.get_info)
      end
    end

    results
  end

  #Investigate a method of this object.
  def foorth_method_info(name)
    symbol, results = XfOOrth::SymbolMap.map_info(name)
    found = false

    if symbol
      spec, info = map_foorth_exclusive_info(symbol)

      if spec && !spec.has_tag?(:stub)
        (results << ["", ""]).concat(info).concat(spec.get_info)
        found = true
      end

      results << ["Scope", "not found."] unless found
    end

    results
  end

  #Get the lineage of this object.
  def lineage
    foorth_name + " < " + self.class.lineage
  end


end
