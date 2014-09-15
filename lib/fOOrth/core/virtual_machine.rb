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

    end

    #Get the fOOrth class of this virtual machine
    def foorth_class
      VirtualMachine
    end

    #Does this object have exclusive methods defined on it?
    def has_exclusive?
      true
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

    alias :cache_shared_method :cache_exclusive_method

    #Remove the specified method from this class. The method is still
    #accessible if defined in a super class or mixin.
    #<br>Parameters:
    #* symbol - The symbol of the method to be purged.
    def self.purge_method(symbol)
      remove_method(symbol)
    rescue NameError
    end

    #The \method_missing hook is at the very heart of the fOOrth language
    #compiler. It is here that code blocks are added for both shared and
    #exclusive methods.
    #<br>Parameters:
    #* name - The name of the missing method.
    #* args - Any arguments that were passed to that method.
    #* block - Any block that might have passed to the method.
    def method_missing(name, *args, &block)
      if link_exclusive_method(name) || @foorth_parent.link_shared_method(name, self)
        send(name, *args, &block)
      else
        super
      end
    end


  end

end
