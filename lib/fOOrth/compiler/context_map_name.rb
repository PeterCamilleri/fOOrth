# coding: utf-8

#* compiler/context_map_name.rb - The fOOrth language mapping of names in a context.
module XfOOrth

  #A class for the management of global, hierarchical, and nested compile
  #time contexts.
  class Context

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
        do_vm_target_map       ||
        spec_error

      else
        @data[@symbol]         ||
        do_object_class_map    ||
        do_vm_target_map       ||
        $FOORTH_GLOBALS[@name] ||
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
