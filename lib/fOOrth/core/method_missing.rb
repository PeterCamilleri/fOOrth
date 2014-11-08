# coding: utf-8

#* core/method_missing.rb - Support for caching and purging shared methods.
module XfOOrth
  #* \MethodMissing - Support for the dynamic linking and caching of shared methods.
  module MethodMissing

    #The \method_missing hook is at the very heart of the fOOrth language
    #compiler. It is here that code blocks are added for shared methods.
    #<br>Parameters:
    #* symbol - The symbol of the missing method.
    #* args - Any arguments that were passed to that method.
    #* block - Any block that might have passed to the method.
    def method_missing(symbol, *args, &block)
      if foorth_class.link_shared_method(symbol, self.class)
        send(symbol, *args, &block)
      elsif (names = SymbolMap.unmap(symbol))
        report_method_missing_error(symbol, names)
      else
        super
      end
    end

    #The common point for reporting a method missing error
    #<br>Parameters:
    #* symbol - The symbol that was sent.
    #* names - The name or names that were not found.
    def report_method_missing_error(symbol, names)
      names = names[0] unless names.length > 1
      error "A #{self.foorth_name} does not understand #{names} (#{symbol.inspect})."
    end

  end

end
