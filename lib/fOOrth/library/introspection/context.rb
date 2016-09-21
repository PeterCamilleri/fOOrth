# coding: utf-8

#* library/introspection/context.rb - Context support for introspection.
module XfOOrth

  #Get information about this compiler context.
  class Context

    #Get introspection info.
    #<br>Endemic Code Smells
    #* :reek:FeatureEnvy :reek:TooManyStatements
    def get_info
      results = [["Level", depth]]

      @data.each do |key, value|
        results << ["", ""]

        if value.is_a?(AbstractWordSpec)
          results << ["Name", SymbolMap.unmap(key)]
          results << ["Mapping", key]
          results.concat(value.get_info)
        else
          results << ["Name",  key]
          results << ["Value", value]
        end

      end

      if (prev = self.previous)
        results.concat([["", ""]]).concat(prev.get_info)
      end

      results
    end
  end

end
