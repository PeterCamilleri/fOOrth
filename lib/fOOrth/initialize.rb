# coding: utf-8

#* initialize.rb - The initialize method for the virtual machine
module XfOOrth

  #* initialize.rb - The initialize method for the virtual machine
  class VirtualMachine

    #Set true for verbose compiler play-by-plays and detailed error reports.
    attr_accessor :debug

    #Set true to print out the data stack after every interactive line is processed.
    attr_accessor :show_stack

    #The descriptive name of this virtual machine.
    attr_reader :name

    #The thread data associated with this virtual machine.
    attr_reader :data

    #Create an new instance of a fOOrth virtual machine
    #<br>Parameters:
    #* name - An optional string that describes this virtual machine instance.
    #<br>Note
    #* A XfOOrthError will be raised if an attempt is made to create more than
    #  one virtual machine on a thread.
    def initialize(name='-')
      @name, @debug, @show_stack, @data = name, false, false, {}

      #Bring the major sub-systems to a known state.
      interpreter_reset
      compiler_reset

      connect_vm_to_thread
    end

    #Create a copy of a donor vm instance.
    #<br>Parameters:
    #* name - An optional string that describes this virtual machine instance.
    def foorth_copy(name)
      copy = self.clone
      copy.reinitialize(name)
      copy
    end

    #Get the vm ready for operation
    #<br>Parameters:
    #* name - A string that describes this virtual machine instance.
    def reinitialize(name)
      @data_stack = @data_stack.clone
      @name       = name
      @data       = @data.full_clone
    end

    #Connect the vm to a thread variable.
    def connect_vm_to_thread
      #Check for duplicates.
      current = Thread.current
      error "F60: Only one virtual machine allowed per thread" if current[:vm]

      #This virtual machine is associated with this thread.
      current[:vm] = self
      @start_time  = Time.now
    end
  end

end
