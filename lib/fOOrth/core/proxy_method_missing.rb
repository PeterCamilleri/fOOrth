# coding: utf-8

#* core/proxy_method_missing.rb - Support for caching and purging shared
#  methods in proxy classes.
module XfOOrth
  #* \ProxyMethodMissing - Support for the dynamic linking and caching of
  #  shared methods in proxy classes.
  module ProxyMethodMissing

    #The \method_missing hook is at the very heart of the fOOrth language
    #compiler. It is here that code blocks are added for shared methods.
    #<br>Parameters:
    #* symbol - The symbol of the missing method.
    #* args - Any arguments that were passed to that method.
    #* block - Any block that might have passed to the method.
    def method_missing(symbol, *args, &block)
      if foorth_class.link_proxy_method(symbol, self)
        send(symbol, *args, &block)
      elsif (names = SymbolMap.unmap(symbol))
        report_method_missing_error(symbol, names)
      else
        super
      end
    end

  end

end
