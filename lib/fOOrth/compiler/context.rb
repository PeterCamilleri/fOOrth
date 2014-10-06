# coding: utf-8

#* context.rb - The compile progress context manager of the fOOrth language system.
module XfOOrth

  #A class for the management of global, hierarchical, and nested compile
  #time contexts.
  class Context

    #Setup an instance of compiler context.
    #<br>Parameters:
    #* klass - the fOOrth class that is the leaf of the instance search tree.
    def initialize(previous, klass, mode, ctrl)
      @previous, @klass, @mode, @ctrl = previous, klass, mode, ctrl
      @fwd_map = {}
    end

    #Map a name to an [symbol, action]
    #<br>Parameters:
    #* name - The string to be mapped.
    #<br>Returns:
    #* The specification that corresponds to the name or nil if none found.
    def map(name)
      if (symbol = SymbolMap.map(name))
        map_local(symbol) ||
        map_instance(symbol) ||
        map_default(name, symbol)
      end
    end

    #Map a symbol to a specification via the locally defined contexts.
    #<br>Parameters:
    #* symbol - The symbol to be mapped.
    #<br>Returns:
    #* The specification that corresponds to the symbol or nil if none found.
    def map_local(symbol)
      @fwd_map[symbol] || (@previous && @previous.map_local(symbol))
    end

    #Map a symbol to a specification via the class hierarchy.
    #<br>Parameters:
    #* symbol - The symbol to be mapped.
    #<br>Returns:
    #* The specification that corresponds to the symbol or nil if none found.
    def map_instance(symbol)
      (@klass && @klass.map_instance(symbol)) ||
      (@previous && @previous.map_local(symbol))
    end

    #Map a name to an specification based on the text of the name.
    #<br>Parameters:
    #* name - The name to be mapped.
    #* symbol - The symbol to be mapped.
    #<br>Returns:
    #* The [symbol, action] that corresponds to the name or nil if none found.
    def map_default(_name, _symbol)

    end

  end



end