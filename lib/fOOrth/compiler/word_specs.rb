# coding: utf-8

#* compiler/word_specs.rb - The classes that support the specification of the
#  compile and run-time behaviors of fOOrth definitions of all sorts.
module XfOOrth

  #The abstract base class for all of the different sorts of word specs.
  class AbstractWordSpec

    #The compile-time text inserted into the buffer.
    attr_reader :builds

    #The run-time action, a block that gets linked to the symbol.
    attr_reader :does

    #The attributes tagged to this specification.
    attr_reader :tags

    #Set up the method spec.
    #<br>Parameters:
    #* name - The string that maps to the symbol.
    #* symbol - The symbol that the name maps to.
    #* tags - A an array of tags.
    #<br>These may include:
    #* :immediate - The word is executed, even in compile modes.
    def initialize(name, symbol, tags=[], &block)
      @tags = tags
      @does = block || lambda {|vm|
        error "A #{self.foorth_name} does not understand #{name} (#{symbol.inspect})."
      }

      build_builds_string(name, symbol)
    end

    #Transfer needed info to a Token object for compiling.
    #<br>Parameters:
    #* token - The Token object to be filled with wisdom.
    def build_on(token)
      token << builds
      token.add_tags(export_tags)
    end

    #Look up an tag of interest.
    def has_tag?(tag)
      @tags.include?(tag)
    end

    #The tags that are to be exported.
    def export_tags
      @tags
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
  end

  #A class used to specify the compile of fOOrth classes.
  class ClassSpec < AbstractWordSpec
    #Generate the Ruby code for this fOOrth class.
    #<br>Parameters:
    #* name - The string that maps to the symbol.
    #* _symbol - The symbol that the name maps to. Unused
    def build_builds_string(name, _symbol)
      @builds = "vm.push(#{name}); "
    end
  end

  #A class used to specify the compile of fOOrth variable.
  class LocalVarSpec < AbstractWordSpec
    #Generate the Ruby code for this fOOrth variable.
    #<br>Parameters:
    #* _name - The string that maps to the symbol.  Unused
    #* symbol - The symbol that the name maps to.
    def build_builds_string(_name, symbol)
      @builds = "vm.push(#{symbol}); "
    end
  end

  #A class used to specify the compile of fOOrth variable.
  class LocalSpec < AbstractWordSpec
    #Generate the Ruby code for this fOOrth variable.
    #<br>Parameters:
    #* _name  - The string that maps to the symbol. Unused
    #* symbol - The symbol that the name maps to.
    def build_builds_string(_name, symbol)
      @builds = "vm.context[#{symbol.inspect}].does.call(vm); "
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
    #  with the text of the command macro. Further, this string is evaluated
    #  in order to get the string desired, so it must contain all the Ruby
    #  trappings of a string, like quotes etc. If it contains double quotes,
    #  then it may also insert any available pseudo-closure #{} data like
    #  the name, @symbol, an expression, or global data.
    #<br>Endemic Code Smells
    #* :reek:UnusedParameters
    def build_builds_string(_name, _symbol)
      @builds = @tags[-1]
    end

    #The tags that are to be exported. All but the last one.
    def export_tags
      @tags[0..-2]
    end

  end
end
