# coding: utf-8

#* core/virtual_machine.rb - The core connection to the virtual machine.
module XfOOrth

  #* core/virtual_machine.rb - The core connection to the virtual machine.
  class VirtualMachine
    @dictionary = Hash.new

    #Class definitions stand in for the fOOrth virtual machine class.
    class << self
      #A hash containing the methods defined for instances of this class.
      #<br>It maps (a symbol) => (a lambda block)
      attr_reader :dictionary

      #The fOOrth parent class of VirtualMachine is Object.
      def foorth_parent
        XfOOrth.object_class
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

      #Remove the specified method from this class. The method is still
      #accessible if defined in a super class or mixin.
      #<br>Parameters:
      #* symbol - The symbol of the method to be purged.
      def purge_method(symbol)
        remove_method(symbol)
      rescue NameError
      end

      #Search the object class dictionaries for the named instance method and add
      #it to the target class.
      #<br>Parameters:
      #* name - The symbol of the method name to be added.
      #* target_class - The class to which the method is added.
      #<br>Returns:
      #* True on success else false if name could not be found.
      #<br>Endemic Code Smells
      # :reek:FeatureEnvy
      def link_shared_method(name)
        current = self

        while current
          dictionary = current.dictionary

          if dictionary.has_key?(name)
            self.cache_shared_method(name, &dictionary[name])
            return true
          end

          current = current.foorth_parent
        end

        false
      end

      #Add an instance method to this fOOrth class.
      #<br>Parameters:
      #* symbol - The method symbol to be added.
      #* block - The block associated with this method.
      #<br>Note:
      #* The method cache for this symbol is purged for this class and all child
      #  classes except where the child classes already have there own method.
      def add_shared_method(symbol, &block)
        @dictionary.delete(symbol)
        purge_shared_method(symbol)
        @dictionary[symbol] = block
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
        purge_method(symbol) unless @dictionary.has_key?(symbol)
      end

    end

    #Get the fOOrth class of this virtual machine
    def foorth_class
      VirtualMachine
    end

    #Does this object have exclusive methods defined on it?
    def has_exclusive?
      !@dictionary.empty?
    end

    #Add an exclusive method to this fOOrth object.
    #<br>Parameters:
    #* symbol - The method symbol to be added.
    #* block - The block associated with this method.
    def add_exclusive_method(symbol, &block)
      @dictionary[symbol] = block

      #If already cached, override it!
      if responds_to?(symbol)
        cache_exclusive_method(symbol, &block)
      end
    end

    #Search the exclusive dictionary for a method for symbol. If it is found,
    #add it to this object.
    #<br>Parameters:
    #* symbol - The symbol of the method name to be added.
    #<br>Returns:
    #* True on success else false if name could not be found.
    def link_exclusive_method(symbol)
      if @dictionary.has_key?(symbol)
        cache_exclusive_method(symbol, &@dictionary[symbol])
        true
      else
        false
      end
    end

    #Cache the specified code block by adding it as a singleton method.
    #Thus this method is only available to this object and any clones that are
    #subsequently created.
    #<br>Parameters:
    #* symbol - The symbol that names the method.
    #* block - The code block to be executed.
    def cache_exclusive_method(symbol, &block)
      define_singleton_method(symbol, &block)
    end

    #The \method_missing hook is at the very heart of the fOOrth language
    #compiler. It is here that code blocks are added for both shared and
    #exclusive methods.
    #<br>Parameters:
    #* name - The name of the missing method.
    #* args - Any arguments that were passed to that method.
    #* block - Any block that might have passed to the method.
    def method_missing(name, *args, &block)
      if link_exclusive_method(name) || VirtualMachine.link_shared_method(name)
        send(name, *args, &block)
      else
        super
      end
    end

  end

end
