# coding: utf-8

#* compiler/word_specs.rb - The classes that support the specification of the
#  compile and run-time behaviors of fOOrth definitions of all sorts.
module XfOOrth

  #The abstract base class for all of the different sorts of word specs.
  class AbstractWordSpec

    #The compile specification, typically a string to be appended to the
    #the emitted Ruby code for calling this method.
    attr_reader :builds

    #The run-time specification, typically a block that gets linked to the
    #symbol for this method as a Ruby method.
    attr_reader :does

    #Set up the method spec.
    #<br>Parameters:
    #* name - The string that maps to the symbol.
    #* symbol - The symbol that the name maps to.
    #* attributes - A an array of attributes.
    #<br>These may include:
    #* :immediate - The word is executed, even in compile modes.
    def initialize(name, symbol, attributes=[], &block)
      @attributes = attributes
      @does = block || lambda {|vm| error "No block for #{name} #{symbol}."}
      build_builds_string(name, symbol)
    end

    #Look up an attribute of interest.
    def has_attribute?(attr)
      @attributes.include?(attr)
    end

    #A place holder that should never be called.
    def build_builds_string(_name, _symbol)
      error "Should never call the abstract build_builds_string method."
    end

  end

  #A class used to specify the compile of VM words.
  class VmWordSpec < AbstractWordSpec

    #Generate the Ruby code for this method.
    #<br>Parameters:
    #* _name - The string that maps to the symbol. Unused
    #* symbol - The symbol that the name maps to.
    def build_builds_string(_name, symbol)
      @builds = "vm.#{symbol}; "
    end

  end

  #A class used to specify the compile of methods of a class or object.
  class MethodWordSpec < AbstractWordSpec

    #Generate the Ruby code for this method.
    #<br>Parameters:
    #* name - The string that maps to the symbol.
    #* symbol - The symbol that the name maps to.
    def build_builds_string(name, symbol)
      if name[0] == '~'
        @builds = "self.#{symbol}(vm); "
      else
        @builds = "vm.pop.#{symbol}(vm); "
      end
    end

  end

  #A class used to specify the compile of dyadic operators.
  class DyadicWordSpec < AbstractWordSpec

    #Generate the Ruby code for this dyadic operator.
    #<br>Parameters:
    #* _name - The string that maps to the symbol. Unused
    #* symbol - The symbol that the name maps to.
    def build_builds_string(_name, symbol)
      @builds = "vm.swap_pop.#{symbol}(vm); "
    end

  end

  #A class used to specify the compile of fOOrth classes.
  class ClassWordSpec < AbstractWordSpec

    #Generate the Ruby code for this fOOrth class.
    #<br>Parameters:
    #* name - The string that maps to the symbol.
    #* _symbol - The symbol that the name maps to. Unused
    def build_builds_string(name, _symbol)
      @builds = "vm.push(XfOOrth.all_classes[#{name.embed}]); "
    end

  end

  #A class used to specify the compile of fOOrth variable.
  class VariableWordSpec < AbstractWordSpec

    #Generate the Ruby code for this fOOrth variable.
    #<br>Parameters:
    #* _name - The string that maps to the symbol.  Unused
    #* symbol - The symbol that the name maps to.
    def build_builds_string(_name, symbol)
      @builds = "vm.push(#{symbol}); "
    end

  end

  #A class used to specify the compile of fOOrth macros.
  class MacroWordSpec < AbstractWordSpec

    #Generate the Ruby code for this macro.
    #<br>Parameters:
    #* _name - The string that maps to the symbol. Unused
    #* _symbol - The symbol that the name maps to. Unused
    #<br>Note:
    #* The last entry in the attributes array is expected to be a string
    #  with the text of the command macro. Further, this string is evaluated
    #  in order to get the string desired, so it must contain all the Ruby
    #  trappings of a string, like quotes etc. If it contains double quotes,
    #  then it may also insert any available pseudo-closure #{} data like
    #  the name, symbol, an expression, or global data.
    #<br>Endemic Code Smells
    #* :reek:UnusedParameters
    def build_builds_string(name, symbol)
      @builds = eval(@attributes[-1])
    end

  end

end
