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
    #* presym - A pre-assigned symbol value or nil to generate a symbol.
    #<br>Returns:
    #* The symbol that corresponds to the name.
    def self.add_entry(name, presym=nil)
      prefix = '' unless ['@', '$'].include?(prefix = name[0])

      @sync.synchronize do
        unless (symbol = @fwd_map[name])
          symbol = presym || (prefix + (@incrementer.succ!)).to_sym
          connect(name, symbol)
        else
          error "Attempt to redefine #{name}." if presym && presym != symbol
        end

        symbol
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

    #Set up the internal workings of the mapping hashes.
    private
    def self.connect(name, symbol)
      if (rev_entry = @rev_map[symbol])
        rev_entry << name
      else
        @rev_map[symbol] = [name]
      end

      @fwd_map[name] = symbol
    end
  end
end