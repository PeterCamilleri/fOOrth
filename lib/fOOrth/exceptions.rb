# coding: utf-8

#* exceptions.rb - Exception classes for the foorth language interpreter.
module Xfoorth
  #The generalize exception used by all foorth specific exceptions.
  class XfoorthError < StandardError; end

  #The exception raised to force the foorth language system to exit.
  class ForceExit    < StandardError; end

  #The exception raised to silently force the foorth language system to exit.
  class SilentExit    < StandardError; end

  #The exception raised to force the foorth language system to abort execution.
  class ForceAbort   < StandardError; end
end