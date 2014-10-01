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
    #* old_symbol - The symbol the name is to be mapped to or nil if a new
    #  symbol is to be created.
    #<br>Returns:
    #* The [symbol, action] that corresponds to the name.
    def self.add_global_entry(name, action, old_symbol=nil)
      sync.synchronize do
        if (entry = fwd_map[name])
          error "Attempt to redefine #{name}." unless entry[1] == action
          entry
        else
          new_symbol = old_symbol || (incrementer.succ!).to_sym

          if (rev_entry = rev_map[new_symbol])
            rev_entry << name
          else
            rev_map[new_symbol] = [name]
          end

          fwd_map[name] = [new_symbol, action]
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
    #* A [names] or nil if the symbol is not in the map.
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