# coding: utf-8

require_relative 'context/map_name'
require_relative 'context/tags'
require_relative 'context/locals'

#* compiler/context.rb - The compile progress context manager of the fOOrth
#  language system.
module XfOOrth

  #A class for the management of global, hierarchical, and nested compile time contexts.
  #* compiler/context.rb - \Context constructor, tag support, and local defs.
  class Context

    #The previous context object that this one builds on. Set to nil if there
    #is none.
    attr_reader :previous

    #Setup an instance of compiler context.
    #<br>Parameters:
    #* previous - The previous context object or nil if there is none.
    #* data - A hash of context data.
    def initialize(previous, data={})
      @previous, @data = previous, data
    end

    #How many levels of nested context are there?
    def depth
      1 + (previous ? previous.depth : 0)
    end

    #Is the current nesting level what is expected?
    #<br>Parameters
    #* expected_depth - the expected nesting depth.
    #<br>Notes
    #* Raises an error (F12) on incorrect nesting.
    def check_depth(expected_depth)
      if expected_depth - self.depth != 0
        error "F12: Error, Invalid control/structure nesting."
      end
    end

    #Get the currently define method receiver
    def recvr
      self[:obj] || self[:cls] || self[:vm] || error("F90: No message receiver.")
    end

  end
end
