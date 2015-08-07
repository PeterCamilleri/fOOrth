# coding: utf-8

#* exceptions.rb - Exception classes for the fOOrth language interpreter.
module XfOOrth
  #The generalize exception used by all fOOrth specific exceptions.
  class XfOOrthError < StandardError; end

  #The exception raised to force the fOOrth language system to exit.
  class ForceExit    < StandardError; end

  #The exception raised to silently force the fOOrth language system to exit.
  class SilentExit    < StandardError; end

end