# coding: utf-8

#* library/introspection/vm.rb - Virtual Machine support for introspection.
module XfOOrth

  #* library/introspection/vm.rb - Virtual Machine support for introspection.
  class VirtualMachine

    #Get introspection info.
    def get_info
      results = get_basic_vm_info
      get_instance_variable_info(results)
      get_vm_thread_data_info(results)
      get_exclusive_method_info(results, "Exclusive")

      results
    end

    private

    #Get the vm basic stuff first.
    def get_basic_vm_info
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

      results
    end

    #Get the thread data info.
    def get_vm_thread_data_info(results)
      unless @data.empty?
        results.concat([["", ""], ["Data", "Thread"], ["", ""]])

        @data
          .keys
          .map{|symbol| [SymbolMap.unmap(symbol), symbol]}
          .sort{|first, second| first[0] <=> second[0]}
          .map{|name, symbol| [name, @data[symbol]]}
          .each do |name, value|
            results << [name, value.inspect]
          end
      end
    end

  end

end
