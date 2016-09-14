# coding: utf-8

#* library/introspection/vm.rb - Virtual Machine support for introspection.
module XfOOrth

  #* library/introspection/vm.rb - Virtual Machine support for introspection.
  class VirtualMachine

    #Get introspection info.
    def get_info
      results = [["Name",    foorth_name],
                 ["Ruby",    self.to_s],
                 ["Stack",   @data_stack.inspect],
                 ["Nesting", @context.depth],
                 ["Quotes",  @quotes],
                 ["Debug",   @debug],
                 ["Show",    @show_stack],
                 ["Start",   @start_time]]

      if (source  = @parser && @parser.source)
        results << ["Source", source.source_name]
        results << ["Buffer", source.read_buffer.inspect]
      end

      names = instance_variables.map do |sym|
        if (name = XfOOrth::SymbolMap.unmap(sym.to_s[1..-1].to_sym))
          [name, sym]
        end
      end

      names.compact!

      unless names.empty?
        results.concat([["", ""], ["Data", "Instance"], ["", ""]])

        names.each do |name, sym|
          results << [name, instance_variable_get(sym)]
        end
      end

      unless @data.empty?
        results.concat([["", ""], ["Data", "Thread"], ["", ""]])

        @data
          .keys
          .map{|symbol| [SymbolMap.unmap(symbol), symbol]}
          .sort{|a,b| a[0] <=> b[0]}
          .map{|name, symbol| [name, @data[symbol]]}
          .each do |name, value|
            results << [name, value.inspect]
          end
      end

      if foorth_has_exclusive?
        results.concat([["", ""], ["Methods", "Exclusive"]])

        foorth_exclusive.extract_method_names(:all).sort.each do |name|
          symbol, info = SymbolMap.map_info(name)
          results.concat([["", ""], ["Name", name], info])
          spec, info = map_foorth_exclusive_info(symbol, :shallow)
          results.concat(info).concat(spec.get_info)
        end
      end

      results
    end

  end

end
