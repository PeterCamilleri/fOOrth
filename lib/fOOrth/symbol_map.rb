# coding: utf-8

#* symbol_map.rb - The name mangler for the fOOrth Language System.
module XfOOrth
  #A module used to map strings to unique symbols
  module SymbolMap
    @sync = Mutex.new
    @incrementer = '_000'
    @fwd_map = Hash.new
    @rev_map = Hash.new

    class << self
      #The synchronization semaphore.
      attr_reader :sync

      #The next symbol string in line for assigning.
      attr_reader :incrementer

      #The map from name to symbol.
      attr_reader :fwd_map

      #The map from symbol to name.
      attr_reader :rev_map
    end

    #Add a mapping for a string to a symbol that will not collide with
    #existing symbols.
    #<br>Parameters:
    #* name - The string to be mapped.
    #<br>Returns:
    #* The symbol that corresponds to the name.
    def self.add_entry(name)
      sync.synchronize do
        if symbol = fwd_map[name]
          symbol
        else
          symbol = (incrementer.succ!).to_sym
          rev_map[symbol] = name
          fwd_map[name]   = symbol
        end
      end
    end

    #Get the entry for the mapping string. Return nil if there is no entry.
    #<br>Parameters:
    #* name - The string to be looked up.
    #<br>Returns:
    #* A SymEntry or nil if the symbol is not in the map.
    def self.map(name)
      fwd_map[name]
    end

    #Get the entry for the mapping symbol. Return nil if there is no entry.
    #<br>Parameters:
    #* mapped - The mapping of the desired symbol.
    #<br>Returns:
    #* A SymEntry or nil if the symbol is not in the map.
    #<br>Note:
    #* If multiple symbols share the same mapping, the symbol returned is that
    #  of the one defined first.
    def self.unmap(mapped)
      rev_map[mapped]
    end

    #Reset the incrementer to the given string. This is mostly used for testing.
    #<br>Parameters:
    #* The starting point of the generated symbols.
    #<br>Note:
    #* FOR TESTING ONLY.
    def self.restart(start)
      @incrementer = start
    end

  end

end