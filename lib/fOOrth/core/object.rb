#* object.rb - The generic object class of the fOOrth language system.
module XfOOrth
  #The \XObject class is basis for all fOOrth objects.
  class XObject

    class << self

      #A class field to get the \fOOrth_class that this object belongs to.
      attr_accessor :fOOrth_class

      #Cache the specified code block by adding it as a method on the
      #receiver's class. Thus this method is available to all instances of
      #the fOOrth class of this object.
      #<br>Parameters:
      #* symbol - The symbol that names the method.
      #* block - The code block to be executed.
      def cache_shared_method(symbol, &block)
        define_method(symbol, &block)
      end

    end

    #An instance method to get the fOOrth_class that this object belongs to.
    def fOOrth_class
      self.class.fOOrth_class
    end

    #Get the name of this object.
    def name
      "#{fOOrth_class.name} instance."
    end

    #Does this object have exclusive methods defined on it?
    def has_exclusive?
      instance_variable_defined?(:@exclusive)
    end

    #Add an exclusive method to this fOOrth object.
    #<br>Parameters:
    #* symbol - The method symbol to be added.
    #* block - The block associated with this method.
    def add_exclusive_method(symbol, &block)
      @exclusive ||= Hash.new
      @exclusive[symbol] = block

      #If already cached, override it!
      if responds_to?(symbol)
        cache_exclusive_method(symbol, &block)
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

    #Search the exclusive dictionary for the named method and add
    #it to the target class.
    #<br>Parameters:
    #* name - The symbol of the method name to be added.
    #<br>Returns:
    #* True on success else false if name could not be found.
    def link_exclusive_method(name)
      if has_exclusive? && @exclusive.has_key?(name)
        cache_exclusive_method(name, &@exclusive[name])
        true
      else
        false
      end
    end

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
      if link_exclusive_method(name) || fOOrth_class.link_shared_method(name, self.class)
        send(name, *args, &block)
      else
        super
      end
    end
  end
end
