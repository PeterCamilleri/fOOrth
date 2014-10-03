# coding: utf-8

#* symbol_map.rb - The name mangler for the foorth Language System.
module XfOOrth

  #A module used to map strings to unique symbols
  module SymbolMap
    @sync = Mutex.new
    @incrementer = '_000'
    @fwd_map = Hash.new
    @rev_map = Hash.new

    #Add a global mapping for a string to a symbol that will not collide with
    #existing symbols.
    #<br>Parameters:
    #* name - The string to be mapped.
    #* option - A hash for options.
    #<br>These may include:
    #* :prefix - A prefix string for the generated symbol. Typically '$' for
    #  global variables and '@' for instance variables.
    #* :symbol - A symbol to used for the mapping. No new symbol is created.
    #<br>Returns:
    #* The symbol that corresponds to the name.
    def self.add_entry(name, option = {})
      presym, prefix = option[:symbol], (option[:prefix] || '')

      @sync.synchronize do
        unless (@fwd_map[name])
          symbol = presym || (prefix + (@incrementer.succ!)).to_sym

          if (rev_entry = @rev_map[symbol])
            rev_entry << name unless rev_entry.includes?(name)
          else
            @rev_map[symbol] = [name]
          end

          @fwd_map[name] = symbol
        else
          error "Attempt to redefine #{name}."
        end
      end
    end

    #Get the entry for the mapping string. Return nil if there is no entry.
    #<br>Parameters:
    #* name - The string to be looked up.
    #<br>Returns:
    #* A symbol or nil if the symbol is not in the map.
    def self.map(name)
      @fwd_map[name]
    end

    #Get the entry for the mapping symbol. Return nil if there is no entry.
    #<br>Parameters:
    #* mapped - The mapping of the desired symbol.
    #<br>Returns:
    #* A [names] or nil if the symbol is not in the map.
    def self.unmap(mapped)
      @rev_map[mapped]
    end

    #Reset the incrementer to the given string. This used for testing only.
    #<br>Parameters:
    #* start - The new starting point of the generated symbols.
    #<br>Note:
    #* FOR TESTING ONLY.
    def self.restart(start)
      @incrementer = start
    end
  end
end