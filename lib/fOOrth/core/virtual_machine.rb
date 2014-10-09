# coding: utf-8

#* core/virtual_machine.rb - The core connection to the virtual machine.
module XfOOrth

  #* core/virtual_machine.rb - The core connection to the virtual machine.
  class VirtualMachine
    @shared = Hash.new

    #Class definitions stand in for the fOOrth virtual machine class.
    class << self
      #A hash containing the methods defined for instances of this class.
      #<br>It maps (a symbol) => (a lambda block)
      attr_reader :shared

      #The fOOrth parent class of VirtualMachine is Object.
      def foorth_parent
        XfOOrth.object_class
      end

      #Return a hash of the child classes of VirtualMachine. Since these are
      #not allowed, this is always an empty hash.
      def children
        {}
      end

      #What foorth class is the virtual machine's class? For now we maintain
      #the illusion of normalcy by saying that it is the fOOrth Class class.
      def foorth_class
        XfOOrth.class_class
      end

      #The name of the virtual machine fOOrth class. We don't care if we
      #clobber the Ruby name.
      def name
        "VirtualMachine"
      end

      #Create a new fOOrth subclass of this class. This is not allowed for the
      #VirtualMachine class so this stub merely raises an exception.
      def create_foorth_subclass(_name, _class_base=XClass)
        error "Forbidden operation: (VirtualMachine.create_foorth_subclass)."
      end

      #Create a shared method on this fOOrth class.
      #<br>Parameters:
      #* name - The name of the method to create.
      #* spec_class - The specification class to use.
      #* options - An array of options.
      #* block - A block to associate with the name.
      def create_shared_method(name, spec_class, options, &block)
        sym = SymbolMap.add_entry(name)
        spec = spec_class.new(name, sym, options, &block)
        add_shared_method(sym, spec)
      end

      #Search the object class dictionaries for the named instance method and add
      #it to the target class.
      #<br>Parameters:
      #* name - The symbol of the method name to be added.
      #* target_class - The class to which the method is added.
      #<br>Returns:
      #* True on success else false if name could not be found.
      #<br>Endemic Code Smells
      #* :reek:FeatureEnvy
      def link_shared_method(name)
        current = self

        while current
          dictionary = current.shared

          if dictionary.has_key?(name)
            self.cache_shared_method(name, &dictionary[name].does)
            return true
          end

          current = current.foorth_parent
        end

        false
      end

      #Map the symbol to a specification or nil if there is no mapping.
      def map_shared(symbol)
        shared[symbol] || (foorth_parent && foorth_parent.map_shared(symbol))
      end

      #Add an instance method to this fOOrth class.
      #<br>Parameters:
      #* symbol - The method symbol to be added.
      #* spec - The specification associated with this method.
      #<br>Note:
      #* The method cache for this symbol is purged for this class and all child
      #  classes except where the child classes already have there own method.
      def add_shared_method(symbol, spec)
        @shared.delete(symbol)
        purge_shared_method(symbol)
        @shared[symbol] = spec
      end

      #Cache the specified code block by adding it as a method on the
      #receiver's class. Thus this method is available to all instances of
      #the foorth class of this object.
      #<br>Parameters:
      #* symbol - The symbol that names the method.
      #* block - The code block to be executed.
      def cache_shared_method(symbol, &block)
        define_method(symbol, &block)
      end

      #Purge the instance method cache for the specified symbol.
      def purge_shared_method(symbol)
        purge_method(symbol) unless @shared.has_key?(symbol)
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

    #Get the fOOrth class of this virtual machine
    def foorth_class
      VirtualMachine
    end

    #Does this object have exclusive methods defined on it?
    def has_exclusive?
      instance_variable_defined?(:@exclusive) && !@exclusive.empty?
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
    #  sense, the method is connected to the virtual machine immediately.
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
      if VirtualMachine.link_shared_method(name)
        send(name, *args, &block)
      else
        super
      end
    end

  end

end
