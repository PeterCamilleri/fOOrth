# coding: utf-8

#* compiler/context/map_name.rb - The fOOrth language mapping of names in a context.
module XfOOrth

  #* compiler/context/map_name.rb - The fOOrth language mapping of names in a context.
  class Context

    #Map a name to a specification.
    #<br>Parameters:
    #* name - The string to be mapped.
    #<br>Returns:
    #* The specification that corresponds to the name or nil if none found.
    def map_with_defaults(name)
      if (@symbol = SymbolMap.map(@name = name))
        do_map_name ||
          case @name[0]
          when '.'
            TosSpec.new(@name, @symbol, [:temp])

          when '~'
            SelfSpec.new(@name, @symbol, [:temp])

          else
            spec_error
          end
      end
    end

    #Map a name to a specification.
    #<br>Parameters:
    #* name - The string to be mapped.
    #<br>Returns:
    #* The specification that corresponds to the name or nil if none found.
    def map_without_defaults(name)
      if (@symbol = SymbolMap.map(@name = name))
        do_map_name
      end
    end

    #Private methods follow.
    private

    #Do a search of dictionaries based on the syntax of the name.
    def do_map_name
      self[@symbol]        ||
      do_target_class_map  ||
      do_target_object_map ||
      do_target_vm_map     ||
      do_object_class_map  ||
      do_global_map
    end

    #Do a search of the Object class for the item.
    def do_object_class_map
      Object.map_foorth_shared(@symbol)
    end

    #Do a search of the :cls tag if it is specified.
    def do_target_class_map
      (tc = self[:cls]) && tc.map_foorth_shared(@symbol)
    end

    #Do a search of the :obj tag if it is specified.
    def do_target_object_map
      (to = self[:obj]) && to.map_foorth_exclusive(@symbol)
    end

    #Do a search of the :vm tag if it is specified.
    def do_target_vm_map
      (vm = self[:vm])  && vm.map_foorth_exclusive(@symbol)
    end

    #Do a search of the globals.
    def do_global_map
      $FOORTH_GLOBALS[@symbol]
    end

    #Error: Unable to find a specification.
    def spec_error
      error "F11: ?#{@name}?"
    end

  end
end
