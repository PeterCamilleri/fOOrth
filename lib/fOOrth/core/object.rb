# coding: utf-8

#* The additions to the Ruby Object class required to support fOOrth.
class Object

  #==========================================================================
  # Exclusive Method Support
  #==========================================================================

  #Access/create the object's exclusive fOOrth dictionary.
  #<br>Decree!
  #* This is to be the only reference to @_private_foorth_exclusive!
  def foorth_exclusive
    @_private_foorth_exclusive ||= Hash.new
  end

  #Create an exclusive method on this fOOrth object.
  #<br>Parameters:
  #* name - The name of the method to create.
  #* spec_class - The specification class to use.
  #* options - An array of options.
  #* block - A block to associate with the name.
  #<br>Returns
  #* The spec created for the shared method.
  def create_exclusive_method(name, spec_class, options, &block)
    sym = XfOOrth::SymbolMap.add_entry(name)
    spec = spec_class.new(name, sym, options, &block)
    cache_exclusive_method(sym, &block)
    foorth_exclusive[sym] = spec
  end

  #Load the new exclusive method into the object.
  def cache_exclusive_method(symbol, &block)
    define_singleton_method(symbol, &block)
  rescue TypeError
    error "Exclusive methods not allowed for type: #{self.class.foorth_name}"
  end

  #Map the symbol to a specification or nil if there is no mapping.
  def map_foorth_exclusive(symbol)
    foorth_exclusive[symbol] || self.class.map_foorth_shared(symbol)
  end


  #==========================================================================
  # Missing Method Handler
  #==========================================================================

  #The \method_missing hook is used to provide meaningful error messages
  #when problems are encountered.
  #<br>Parameters:
  #* symbol - The symbol of the missing method.
  #* args - Any arguments that were passed to that method.
  #* block - Any block that might have passed to the method.
  def method_missing(symbol, *args, &block)
    if (names = XfOOrth::SymbolMap.unmap(symbol))
      names = names[0] unless names.length > 1
      error "A #{self.foorth_name} does not understand #{names} (#{symbol})."
    else
      super
    end
  end
end

# Core Tsunami -- All that follows will be swept away... eventually...

require_relative 'exclusive'
require_relative 'shared_cache'
require_relative 'method_missing'

#* core/object.rb - The generic object class of the fOOrth language system.
module XfOOrth

  #The \XObject class is basis for all fOOrth objects.
  class XObject
    include Exclusive
    extend  SharedCache
    include MethodMissing

    class << self

      #A class instance variable to get the \foorth_class of this object.
      attr_accessor :foorth_class

    end

    #Get the fOOrth class of this object.
    def foorth_class
      self.class.foorth_class
    end

    #Get the name of this object.
    def foorth_name
      "#{foorth_class.foorth_name} instance"
    end

  end
end
