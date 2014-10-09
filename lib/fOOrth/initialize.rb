# coding: utf-8

#* initialize.rb - The initialize method for the virtual machine
module XfOOrth

  #* initialize.rb - The initialize method for the virtual machine
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
    #* A XfOOrthError will be raised if an attempt is made to create more than
    #  one virtual machine on a thread.
    def initialize(name='-', source={})
      @name          = name
      @exclusive     = source
      @debug         = false
      @foorth_parent = XfOOrth.object_class

      #Bring the major sub-systems to a known state.
      self.interpreter_reset
      self.compiler_reset

      #Check for duplicates.
      current = Thread.current
      error "Only one virtual machine allowed per thread" if current[:vm]

      #This virtual machine is associated with this thread.
      current[:vm] = self
    end

  end

end
