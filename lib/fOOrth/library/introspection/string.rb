# coding: utf-8

#* library/introspection/string.rb - String support for introspection.
class String

  #Scan all classes for information about a method.
  #<br>Endemic Code Smells
  #* :reek:DuplicateMethodCall :reek:FeatureEnvy :reek:TooManyStatements
  def foorth_method_scan
    symbol, results = XfOOrth::SymbolMap.map_info(self)
    found = false

    symbol && $FOORTH_GLOBALS.values
      .select {|entry| entry.has_tag?(:class)}
      .collect {|spec| spec.new_class}
      .sort {|first, second| first.foorth_name <=> second.foorth_name}
      .each do |klass|
        shared_spec, shared_info = klass.map_foorth_shared_info(symbol, :shallow)

        if shared_spec
          results
            .concat([["", ""]])
            .concat(shared_info)
            .concat(shared_spec.get_info)
        end

        excl_spec, excl_info = klass.map_foorth_exclusive_info(symbol, :shallow)

        if excl_spec
          results
            .concat([["", ""]])
            .concat(excl_info)
            .concat(excl_spec.get_info)
        end

        found ||= (shared_spec || excl_spec)
      end

    results << ["Scope", "not found in any class."] if symbol && !found

    results
  end

end
