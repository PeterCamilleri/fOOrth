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
      @fwd = {}

    end

    #Map a name to an [symbol, action]
    #<br>Parameters:
    #* name - The string to be mapped.
    #<br>Returns:
    #* The [symbol, action] that corresponds to the name or nil if none found.
    def map(name)
      map_local(name) || map_instance(name) || map_global(name) || map_default(name)
    end

    #Map a name to an [symbol, action] via the locally defined contexts.
    #<br>Parameters:
    #* name - The string to be mapped.
    #<br>Returns:
    #* The [symbol, action] that corresponds to the name or nil if none found.
    def map_local(name)
      @locals.each do |local|
        if (entry = local.map)
          return entry
        end
      end
    end

    #Map a name to an [symbol, action] via the maps in the current class
    #hierarchy.
    #<br>Parameters:
    #* name - The string to be mapped.
    #<br>Returns:
    #* The [symbol, action] that corresponds to the name or nil if none found.
    def map_instance(name)

    end

    #Map a name to an [symbol, action] via a global entry in the SymbolMap.
    #<br>Parameters:
    #* name - The string to be mapped.
    #<br>Returns:
    #* The [symbol, action] that corresponds to the name or nil if none found.
    def map_global(name)
      SymbolMap.map(name)
    end

    #Map a name to an [symbol, action] based on the text of the name.
    #<br>Parameters:
    #* name - The string to be mapped.
    #<br>Returns:
    #* The [symbol, action] that corresponds to the name or nil if none found.
    def map_default(name)

    end

  end



end