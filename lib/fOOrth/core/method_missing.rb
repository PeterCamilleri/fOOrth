# coding: utf-8

#* core/method_missing.rb - Support for caching and purging shared methods.
module XfOOrth
  #* \MethodMissing - Support for the dynamic linking and caching of shared methods.
  module MethodMissing

    #The \method_missing hook is at the very heart of the fOOrth language
    #compiler. It is here that code blocks are added for shared methods.
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
