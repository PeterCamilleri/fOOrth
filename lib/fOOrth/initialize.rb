# coding: utf-8

#* initialize.rb - The initialize method for the virtual machine
module XfOOrth

  class VirtualMachine

    #Set true for verbose compiler play-by-plays and detailed error reports.
    attr_accessor :debug

    #The descriptive name of this virtual machine.
    attr_reader :name

    #Create an new instance of a fOOrth virtual machine
    #<br>Parameters:
    #* name - An optional string that describes this virtual machine instance.
    #* source - The dictionary used as a source template for the new one. By
    #  default an empty dictionary is used.
    #<br>Note
    #* A
    def initialize(name='-', source={})
      @name          = name
      @dictionary    = source
      @debug         = false
      @foorth_parent = XfOOrth.object_class

      #Bring the major sub-systems to a known state.
      self.interpreter_reset
      self.compiler_reset

      #Check for duplicates.
      error "Only one virtual machine allowed per thread" if Thread.current[:vm]

      #This virtual machine is associated with this thread.
      Thread.current[:vm] = self
    end

  end

end
