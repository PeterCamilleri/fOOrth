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
      if (@symbol = SymbolMap.map(@name = name))
        do_map_name
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

    #Private methods follow.
    private

    #Do a search of dictionaries based on the syntax of the name.
    def do_map_name
      case @name[0]
      when '.'
        do_object_class_map    ||
        do_vm_target_map       ||
        do_default_public_spec

      when '~', '@'
        do_class_target_map    ||
        do_object_target_map   ||
        do_vm_target_map       ||
        spec_error

      when '$'
        spec_error  # Reserved for now.

      when '#'
        spec_error  # Reserved for now.

      else
        @data[@symbol]         ||
        do_object_class_map    ||
        do_vm_target_map       ||
        $ALL_CLASSES[@name]    ||
        spec_error
      end

    end

    #Do a search of the Object class for the item.
    def do_object_class_map
      Object.map_foorth_shared(@symbol)
    end

    #Do a search of the :cls tag if it is specified.
    def do_class_target_map
      (tc = self[:cls]) && tc.map_foorth_shared(@symbol)
    end

    #Do a search of the :obj tag if it is specified.
    def do_object_target_map
      (to = self[:obj]) && to.map_foorth_exclusive(@symbol)
    end

    #Do a search of the :vm tag if it is specified.
    def do_vm_target_map
      (vm = self[:vm]) && vm.map_foorth_exclusive(@symbol)
    end

    #Create a default entry for a method
    def do_default_public_spec
      TosSpec.new(@name, @symbol)
    end

    #Error: Unable to find a specification.
    def spec_error
      error "Unable to find a spec for #{@name} (#{@symbol.inspect})"
    end

  end
end
