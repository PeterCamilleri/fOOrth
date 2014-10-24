# coding: utf-8

#* compiler/context.rb - The compile progress context manager of the fOOrth
#  language system.
module XfOOrth

  #A class for the management of global, hierarchical, and nested compile
  #time contexts.
  class Context

    #The previous context object that this one builds on. Set to nil is there
    #is none.
    attr_reader :previous

    #Setup an instance of compiler context.
    #<br>Parameters:
    #* previous - The previous context object or nil if there is none.
    #* data - A hash of context data.
    def initialize(previous, data={})
      @previous, @data = previous, data
    end

    #Retrieve the data value currently in effect.
    def [](index)
      @data[index] || (previous && previous[index])
    end

    #Set a data value.
    def []=(index,value)
      @data[index] = value
    end

    #Merge in a hash of tag data.
    def merge(new_data)
      @data.merge!(new_data)
    end

    #Map a name to a specification.
    #<br>Parameters:
    #* name - The string to be mapped.
    #<br>Returns:
    #* The specification that corresponds to the name or nil if none found.
    def map(name)
      if (symbol = SymbolMap.map(name))
        self[symbol]                                           ||
        ((vm = self[:vm])     && vm.map_exclusive(symbol))     ||
        ((to = self[:object]) && to.map_exclusive(symbol))     ||
        ((tc = self[:class])  && tc.map_foorth_shared(symbol)) ||
        map_default(name, symbol)
      end
    end

    #Map a name to a specification based on the text of the name.
    #<br>Parameters:
    #* name - The name to be mapped.
    #* symbol - The symbol to be mapped.
    #<br>Returns:
    #* The specification that corresponds to the name.
    #<br>Endemic Code Smells
    #* :reek:UtilityFunction
    #* :reek:FeatureEnvy
    def map_default(name, symbol)
      case name[0]
        when '@', '$'
          VariableWordSpec.new(name, symbol)

        when '.', '~'
          MethodWordSpec.new(name, symbol)

        else
          VmWordSpec.new(name, symbol)
      end
    end

    #Validate a current data value.
    #<br>Parameters:
    #* symbol - The symbol of the value to be tested.
    #* expect - An array of valid values.
    #<br>Note:
    #* Throws a XfOOrthError if the value is not valid.
    #* To check for no value, use [nil] for expect.
    def check_set(symbol, expect)
      current = self[symbol]

      unless expect.include?(current)
        error "Invalid value for #{symbol}: #{current.inspect} not #{expect}"
      end

      true
    end

    #How many levels of nested context are there?
    def depth
      1 + (previous ? previous.depth : 0)
    end
  end
end
