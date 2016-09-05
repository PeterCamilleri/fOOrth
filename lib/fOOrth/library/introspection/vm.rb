# coding: utf-8

#* library/introspection/vm.rb - Virtual Machine support for introspection.
module XfOOrth

  #* library/introspection/vm.rb - Virtual Machine support for introspection.
  class VirtualMachine

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

      results
    end

  end

end
