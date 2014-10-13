# coding: utf-8

#* compiler/word_specs.rb - The classes that support the specification of the
#  compile and run-time behaviors of fOOrth definitions of all sorts.
module XfOOrth

  #The abstract base class for all of the different sorts of word specs.
  class AbstractWordSpec

    #The run-time action, a block that gets linked to the symbol.
    attr_reader :does

    #Set up the method spec.
    #<br>Parameters:
    #* name - The string that maps to the symbol.
    #* symbol - The symbol that the name maps to.
    #* tags - A an array of tags.
    #<br>These may include:
    #* :immediate - The word is executed, even in compile modes.
    def initialize(name, symbol, tags=[], &block)
      @tags = tags
      @does = block || lambda {|vm| error "No block for #{name} #{symbol}."}
      early_builds_string(name, symbol)
    end

    #Get or generate the compile specification. This is a string to be
    #appended to the the emitted Ruby code for calling this method.
    #<br>Parameters:
    #* name - The string (at the point of reference) that maps to the symbol.
    def builds(name)
      @builds || late_builds_string(name)
    end

    #Transfer needed info to a Token object for compiling.
    #<br>Parameters:
    #* token - The Token object to be filled with wisdom.
    #* name - The string (at the point of reference) that maps to the symbol.
    def build_on(token, name)
      token << self.builds(name)
      token.add_tags(@tags)
    end

    #Look up an tag of interest.
    def has_tag?(tag)
      @tags.include?(tag)
    end

    #A place holder for cases where late build is required. All it does is save
    #away the symbol for later use by thd late_builds_string method.
    def early_builds_string(_name, symbol)
      @symbol = symbol
    end

    #A place holder to give clearer error messages.
    def late_builds_string(_name, _symbol)
      error "Why Vinnie? Why?"
    end
  end

  #A class used to specify the compile of VM words.
  class VmWordSpec < AbstractWordSpec
    #Generate the Ruby code for this method.
    #<br>Parameters:
    #* _name - The string that maps to the symbol. Unused
    #* symbol - The symbol that the name maps to.
    def early_builds_string(_name, symbol)
      @builds = "vm.#{symbol}; "
    end
  end

  #A class used to specify the compile of methods of a class or object.
  class MethodWordSpec < AbstractWordSpec
    #Generate the Ruby code for this method.
    #<br>Parameters:
    #* name - The string that maps to the symbol.
    #* symbol - The symbol that the name maps to.
    def late_builds_string(name)
      if name[0] == '~'
        "self.#{@symbol}(vm); "
      else
        "vm.pop.#{@symbol}(vm); "
      end
    end
  end

  #A class used to specify the compile of dyadic operators.
  class DyadicWordSpec < AbstractWordSpec
    #Generate the Ruby code for this dyadic operator.
    #<br>Parameters:
    #* _name - The string that maps to the symbol. Unused
    #* symbol - The symbol that the name maps to.
    def early_builds_string(_name, symbol)
      @builds = "vm.swap_pop.#{symbol}(vm); "
    end
  end

  #A class used to specify the compile of fOOrth classes.
  class ClassWordSpec < AbstractWordSpec
    #Generate the Ruby code for this fOOrth class.
    #<br>Parameters:
    #* name - The string that maps to the symbol.
    #* _symbol - The symbol that the name maps to. Unused
    def early_builds_string(name, _symbol)
      @builds = "vm.push(XfOOrth.all_classes[#{name.embed}]); "
    end
  end

  #A class used to specify the compile of fOOrth variable.
  class VariableWordSpec < AbstractWordSpec
    #Generate the Ruby code for this fOOrth variable.
    #<br>Parameters:
    #* _name - The string that maps to the symbol.  Unused
    #* symbol - The symbol that the name maps to.
    def early_builds_string(_name, symbol)
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
    #* The last entry in the tags array is expected to be a string
    #  with the text of the command macro. Further, this string is evaluated
    #  in order to get the string desired, so it must contain all the Ruby
    #  trappings of a string, like quotes etc. If it contains double quotes,
    #  then it may also insert any available pseudo-closure #{} data like
    #  the name, @symbol, an expression, or global data.
    #<br>Endemic Code Smells
    #* :reek:UnusedParameters
    def late_builds_string(name)
      eval(@tags[-1])
    end
  end
end
