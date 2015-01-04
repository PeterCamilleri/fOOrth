# coding: utf-8

#* compiler/context.rb - The compile progress context manager of the fOOrth
#  language system.
module XfOOrth

  #A class for the management of global, hierarchical, and nested compile
  #time contexts.
  class Context

    #The previous context object that this one builds on. Set to nil if there
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

    #Get the compile tags in effect.
    def tags
      @data[:tags] || []
    end

    #Merge in a hash of tag data.
    def merge(new_data)
      @data.merge!(new_data)
    end

    #Validate a current data value.
    #<br>Parameters:
    #* symbol - The symbol of the value to be tested.
    #* expect - An array of valid values.
    #<br>Note:
    #* Throws a XfOOrthError if the value is not valid.
    #* To check for no value, use [nil] for expect.
    #* Returns true to facilitate testing only.
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

    #Get the currently define method receiver
    def recvr
      self[:obj] || self[:cls] || self[:vm] || error("Undefined receiver.")
    end

    #Create a local method on this context.
    #<br>Parameters:
    #* The name of the method to create.
    #* An array of options.
    #* A block to associate with the name.
    #<br>Returns
    #* The spec created for the shared method.
    def create_local_method(name, options, &block)
      sym = SymbolMap.add_entry(name)
      self[sym] = LocalSpec.new(name, sym, options, &block)
    end

  end
end
