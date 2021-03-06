# coding: utf-8

#* library/introspection/symbol_map.rb - Mapping support for introspection.
module XfOOrth

  #* library/introspection/symbol_map.rb - Mapping support for introspection.
  module SymbolMap

    #Get mapping info for a method name.
    def self.map_info(name)
      symbol = map(name)
      target = symbol ? symbol.to_s : "not found."
      [symbol,  [["Name", name], ["Mapping", target]]]
    end

  end

end

