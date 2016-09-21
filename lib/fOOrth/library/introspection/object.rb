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
    get_instance_variable_info(results)
    get_exclusive_method_info(results, "Exclusive")

    results
  end

  #Investigate a method of this object.
  #<br>Endemic Code Smells
  #* :reek:FeatureEnvy
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

  private

  #Get information about instance variables
  def get_instance_variable_info(results)
    names = instance_variables.map do |sym|
      if (name = XfOOrth::SymbolMap.unmap(sym.to_s[1..-1].to_sym))
        [name, sym]
      end
    end
    .compact
    .sort {|first, second| first[0] <=> second[0] }

    unless names.empty?
      results.concat([["", ""], ["Data", "Instance"], ["", ""]])

      names.each do |name, sym|
        results << [name, instance_variable_get(sym)]
      end
    end
  end


  #Get exclusive method info
  def get_exclusive_method_info(results, designation)
    if foorth_has_exclusive?
      results.concat([["", ""], ["Methods", designation]])

      foorth_exclusive.extract_method_names(:all).sort.each do |name|
        symbol, info = XfOOrth::SymbolMap.map_info(name)
        (results << ["", ""]).concat(info)

        spec, info = map_foorth_exclusive_info(symbol, :shallow)
        results.concat(info).concat(spec.get_info)
      end
    end
  end



end
