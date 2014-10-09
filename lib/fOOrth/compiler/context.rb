# coding: utf-8

#* context.rb - The compile progress context manager of the fOOrth language system.
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
    #* klass - The fOOrth class that is the leaf of the instance search tree.
    #  This is nil if there is no class for this context.
    #* mode - The mode of this context or nil to use the previous mode.
    #* ctrl - The control tag of this context or nil to use the previous tag.
    #<br>Note:
    #* Throws a XfOOrthError if previous and mode are both nil or previous
    #  and klass are both nil.
    def initialize(previous, klass, mode, ctrl)
      error "Invalid context parameters." unless previous || (mode && klass)
      @previous, @klass, @mode, @ctrl = previous, klass, mode, ctrl
      @fwd_map = {}
    end

    #Map a name to a specification.
    #<br>Parameters:
    #* name - The string to be mapped.
    #<br>Returns:
    #* The specification that corresponds to the name or nil if none found.
    def map(name)
      if (symbol = SymbolMap.map(name))
        map_local(symbol)         ||
        klass.map_shared(symbol)  ||
        map_default(name, symbol)
      end
    end

    #Map a symbol to a specification via the locally defined contexts.
    #<br>Parameters:
    #* symbol - The symbol to be mapped.
    #<br>Returns:
    #* The specification that corresponds to the symbol or nil if none found.
    def map_local(symbol)
      @fwd_map[symbol] || (previous && previous.map_local(symbol))
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
        when '@', '$', '_'
          VariableWordSpec.new(name, symbol)

        when '.', '~'
          MethodWordSpec.new(name, symbol)

        else
          VmWordSpec.new(name, symbol)
      end
    end

    #Retrieve the current mode.
    def mode
      @mode || (previous && previous.mode)
    end

    #Validate the current mode
    #<br>Parameters:
    #* modes - An array of valid modes.
    #<br>Note:
    #* Throws a XfOOrthError if the mode is not valid.
    def check_mode(modes)
      unless modes.include?(mode)
        error "Invalid mode: #{mode.inspect} not #{modes.inspect}"
      end
    end

    #Retrieve the current control tag.
    def ctrl
      @ctrl || (previous && previous.ctrl)
    end

    #Validate the current control tag
    #<br>Parameters:
    #* ctrls - An array of valid control tags.
    #<br>Note:
    #* Throws a XfOOrthError if the control tag is not valid.
    #* To check for no control tag, use [nil] for ctrls.
    def check_ctrl(ctrls)
      unless ctrls.include?(ctrl)
        error "Invalid control tag: #{ctrl.inspect} not #{ctrls.inspect}"
      end
    end

    #Retrieve the current klass value.
    def klass
      @klass || previous.klass
    end

  end
end
