# coding: utf-8

#* core/shared_cache.rb - Support for caching and purging shared methods.
module XfOOrth
  #* \SharedCache - Support for caching and purging shared methods.
  module SharedCache

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

end
