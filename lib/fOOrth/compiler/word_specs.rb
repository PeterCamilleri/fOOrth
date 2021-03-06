# coding: utf-8

#* compiler/word_specs.rb - The classes that support the specification of the
#  compile and run-time behaviors of fOOrth definitions of all sorts.
module XfOOrth

  #The abstract base class for all of the different sorts of word specs.
  class AbstractWordSpec

    #The compile-time text inserted into the buffer.
    attr_reader :builds

    #The run-time action; The block that gets linked to the method's symbol.
    attr_reader :does

    #The attributes tagged to this specification.
    attr_reader :tags

    #Set up the method spec.
    #<br>Parameters:
    #* name - The string that maps to the symbol.
    #* symbol - The symbol that the name maps to.
    #* tags - A an array of tags.
    #<br>These include:
    #* :class - This spec defines a class.
    #* :immediate - The word is executed, even in compile modes.
    #* :macro - This spec defines an in-line macro.
    #* :stub - The word is a place holder in the hierarchy.
    #* :temp - A temporary spec used during compilation.
    #* none - Nothing special here. Move along, move along.
    #<br>Endemic Code Smells
    #* :reek:ControlParameter -- false positive
    def initialize(name, symbol, tags, &block)
      @tags = tags
      @does = block || get_stub_action(name, symbol)
      build_builds_string(name, symbol)
    end

    #Get the default action if none is specified.
    def get_stub_action(name, symbol)
      lambda do |*_any|
        f20_error(self, name, symbol)
      end
    end

    #Look up a tag of interest.
    def has_tag?(tag)
      @tags.include?(tag)
    end

  end

  #A class used to specify the compile of VM words.
  class VmSpec < AbstractWordSpec
    #Generate the Ruby code for this method.
    #<br>Parameters:
    #* _name - The string that maps to the symbol. Unused
    #* symbol - The symbol that the name maps to.
    def build_builds_string(_name, symbol)
      @builds = "vm.#{symbol}(vm); "
    end
  end

  #A class used to specify the compile of public methods of a class or object.
  class TosSpec < AbstractWordSpec
    #Generate the Ruby code for this method.
    #<br>Parameters:
    #* _name - The string that maps to the symbol. Unused
    #* symbol - The symbol that the name maps to.
    def build_builds_string(_name, symbol)
      @builds = "vm.pop.#{symbol}(vm); "
    end
  end

  #A class used to specify the compile of private methods of a class or object.
  class SelfSpec < AbstractWordSpec
    #Generate the Ruby code for this method.
    #<br>Parameters:
    #* _name - The string that maps to the symbol. Unused
    #* symbol - The symbol that the name maps to.
    def build_builds_string(_name, symbol)
      @builds = "self.#{symbol}(vm); "
    end
  end

  #A class used to specify the compile of dyadic operators.
  class NosSpec < AbstractWordSpec
    #Generate the Ruby code for this dyadic operator.
    #<br>Parameters:
    #* _name - The string that maps to the symbol. Unused
    #* symbol - The symbol that the name maps to.
    def build_builds_string(_name, symbol)
      @builds = "vm.swap_pop.#{symbol}(vm); "
    end

    #Get the default action if none is specified.
    def get_stub_action(name, symbol)
      lambda do |vm|
        #NOS methods leave an extra item on the stack which must
        #be removed at this time.
        vm.data_stack.pop

        f20_error(self, name, symbol)
      end
    end

  end

  #A class used to specify the compile of fOOrth classes.
  class ClassSpec < AbstractWordSpec
    #Generate the Ruby code for this fOOrth class.
    #<br>Parameters:
    #* \new_class - The class object being specified.
    #* _symbol - The symbol that the name maps to. Unused
    def build_builds_string(new_class, _symbol)
      @new_class = new_class
      @builds = "vm.push(#{new_class.name}); "
    end

    #Give read access to the class for testing.
    attr_reader :new_class
  end

  #A class used to specify the compile of fOOrth instances variables.
  class InstanceVarSpec < AbstractWordSpec
    #Generate the Ruby code for this fOOrth variable.
    #<br>Parameters:
    #* _name - The string that maps to the symbol.  Unused
    #* symbol - The symbol that the name maps to.
    def build_builds_string(_name, symbol)
      @builds = "vm.push(#{'@'+(symbol.to_s)}); "
    end
  end

  #A class used to specify the compile of fOOrth thread variables.
  class ThreadVarSpec < AbstractWordSpec
    #Generate the Ruby code for this fOOrth variable.
    #<br>Parameters:
    #* _name - The string that maps to the symbol.  Unused
    #* symbol - The symbol that the name maps to.
    def build_builds_string(_name, symbol)
      @builds = "vm.push(vm.data[#{symbol.inspect}]); "
    end
  end

  #A class used to specify the compile of fOOrth global variables.
  class GlobalVarSpec < AbstractWordSpec
    #Generate the Ruby code for this fOOrth variable.
    #<br>Parameters:
    #* _name - The string that maps to the symbol.  Unused
    #* symbol - The symbol that the name maps to.
    def build_builds_string(_name, symbol)
      @builds = "vm.push(#{'$' + symbol.to_s}); "
    end
  end

  #A class used to specify the compile of fOOrth variable.
  class LocalSpec < AbstractWordSpec
    #Generate the Ruby code for this fOOrth variable.
    #<br>Parameters:
    #* _name  - The string that maps to the symbol. Unused
    #* symbol - The symbol that the name maps to.
    def build_builds_string(_name, symbol)
      @builds = "instance_exec(vm, &vm.context[#{symbol.inspect}].does); "
    end
  end

  #A class used to specify the compile of fOOrth macros.
  class MacroSpec < AbstractWordSpec
    #Generate the Ruby code for this macro.
    #<br>Parameters:
    #* _name - The string that maps to the symbol. Unused
    #* _symbol - The symbol that the name maps to. Unused
    #<br>Note:
    #* The last entry in the tags array is expected to be a string
    #  with the text of the command macro.
    def build_builds_string(_name, _symbol)
      @builds = @tags[-1]
    end
  end
end
