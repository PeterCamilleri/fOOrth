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

    #Get the current target.
    def target
      self[:obj] || self[:cls] || self[:vm] || no_target_error
    end

    #Get the current target object.
    def target_object
      self[:obj] || no_target_error
    end

    #Get the current target class.
    def target_class
      self[:cls] || no_target_error
    end

    #Signal that no receiver was found in this context.
    #This is an internal error indication.
    def no_target_error
      error("F90: No target found in context.")
    end
  end
end
