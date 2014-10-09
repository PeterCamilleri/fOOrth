# coding: utf-8

#* core/object.rb - The generic object class of the fOOrth language system.
module XfOOrth

  #The \XObject class is basis for all fOOrth objects.
  class XObject

    class << self

      #A class instance variable to get the \foorth_class of this object.
      attr_accessor :foorth_class

      #Cache the specified code block by adding it as a method on the
      #receiver's class. Thus this method is available to all instances of
      #the foorth class of this object.
      #<br>Parameters:
      #* symbol - The symbol that names the method.
      #* block - The code block to be executed.
      def cache_shared_method(symbol, &block)
        define_method(symbol, &block)
      end

      #Remove the specified method from this class. The method is still
      #accessible if defined in a super class or mixin.
      #<br>Parameters:
      #* symbol - The symbol of the method to be purged.
      def purge_method(symbol)
        remove_method(symbol)
      rescue NameError
      end

    end

    #Get the fOOrth class of this object.
    def foorth_class
      self.class.foorth_class
    end

    #Get the name of this object.
    def name
      "#{foorth_class.name} instance."
    end

    #Does this object have exclusive methods defined on it?
    def has_exclusive?
      instance_variable_defined?(:@exclusive)
    end

    #Create an exclusive method on this fOOrth object.
    #<br>Parameters:
    #* The name of the method to create.
    #* The specification class to use.
    #* An array of options.
    #* A block to associate with the name.
    def create_exclusive_method(name, spec_class, options, &block)
      sym = SymbolMap.add_entry(name)
      spec = spec_class.new(name, sym, options, &block)
      add_exclusive_method(sym, spec)
    end

    #Map the symbol to a specification or nil if there is no mapping.
    def map_exclusive(symbol)
      @exclusive[symbol] || foorth_class.map_shared(symbol)
    end

    #Add an exclusive method to this fOOrth object.
    #<br>Parameters:
    #* symbol - The method symbol to be added.
    #* spec - The specification associated with this method.
    #<br>Note:
    #* Since exclusive methods are not subject to inheritance in the normal
    #  sense, the method is connected to the object immediately.
    def add_exclusive_method(symbol, spec)
      @exclusive ||= Hash.new
      @exclusive[symbol] = spec
      define_singleton_method(symbol, &spec.does)
    end

    #The \method_missing hook is at the very heart of the fOOrth language
    #compiler. It is here that code blocks are added for both shared and
    #exclusive methods.
    #<br>Parameters:
    #* name - The name of the missing method.
    #* args - Any arguments that were passed to that method.
    #* block - Any block that might have passed to the method.
    def method_missing(name, *args, &block)
      if foorth_class.link_shared_method(name, self.class)
        send(name, *args, &block)
      else
        super
      end
    end
  end
end
