# coding: utf-8

#* symbol_map.rb - The name mangler for the foorth Language System.
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
    #* action - The compiler action associated with this name.
    #<br>Returns:
    #* The symbol that corresponds to the name.
    def self.add_entry(name, action)
      sync.synchronize do
        if (entry = fwd_map[name])
          error "Attempt to redefine #{name}." unless entry[1] == action
          entry
        else
          symbol = (incrementer.succ!).to_sym
          rev_map[symbol] = name
          fwd_map[name]   = [symbol, action]
        end
      end
    end

    #Add a special mapping for a string to the specified symbol
    #<br>Parameters:
    #* name - The string to be mapped.
    #* symbol - The symbol the name is to be mapped to.
    #* action - The compiler action associated with this name.
    #<br>Returns:
    #* The symbol that corresponds to the name.
    #<br>Exceptions:
    #* Raises a XfOOrthError exception if an attempt is made to change a mapping.
    def self.add_special(name, symbol, action)
      sync.synchronize do
        if (entry = fwd_map[name])
          error "Attempt to redefine #{name}." unless entry == [symbol, action]
          entry
        else
          rev_map[symbol] = name
          fwd_map[name]   = [symbol, action]
        end
      end
    end

    #Get the entry for the mapping string. Return nil if there is no entry.
    #<br>Parameters:
    #* name - The string to be looked up.
    #<br>Returns:
    #* A symbol, action or nil if the symbol is not in the map.
    def self.map(name)
      fwd_map[name]
    end

    #Get the entry for the mapping symbol. Return nil if there is no entry.
    #<br>Parameters:
    #* mapped - The mapping of the desired symbol.
    #<br>Returns:
    #* A symbol or nil if the symbol is not in the map.
    def self.unmap(mapped)
      rev_map[mapped]
    end

    #Reset the incrementer to the given string. This used for testing only.
    #<br>Parameters:
    #* The starting point of the generated symbols.
    #<br>Note:
    #* FOR TESTING ONLY.
    def self.restart(start)
      @incrementer = start
    end

  end

end