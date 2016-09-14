# coding: utf-8

#* library/introspection/string.rb - String support for introspection.
class String

  #Scan all classes for information about a method.
  def foorth_method_scan
    symbol, results = XfOOrth::SymbolMap.map_info(self)
    found = false

    symbol && $FOORTH_GLOBALS.values
      .select {|entry| entry.has_tag?(:class)}
      .collect {|spec| spec.new_class}
      .sort {|a,b| a.foorth_name <=> b.foorth_name}
      .each do |klass|
        spec, info = klass.map_foorth_shared_info(symbol, :shallow)
        found |= spec && (results << ["", ""]).concat(info).concat(spec.get_info)

        spec, info = klass.map_foorth_exclusive_info(symbol, :shallow)
        found |= spec && (results << ["", ""]).concat(info).concat(spec.get_info)
      end

    results << ["Scope", "not found in any class."] if symbol && !found

    results
  end

end
