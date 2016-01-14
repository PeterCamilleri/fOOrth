# coding: utf-8

#* initialize.rb - The initialize method for the virtual machine
module XfOOrth

  #* initialize.rb - The initialize method for the virtual machine
  class VirtualMachine

    #Get or create a virtual machine for this thread.
    #<br>Paramters:
    #* name - The name of the virtual machine, if one is created. If a virtual
    #  machine already exists for this thread, this parameter is ignored.
    #<br>Note: Non-intuitive code.
    #* VitualMachine.new connects to the thread, setting up
    #  \Thread.current[:vm] as a side-effect. Thus it is not done here.
    def self.vm(name='-')
      Thread.current[:vm] || VirtualMachine.new(name)
    end

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
      self.reset.connect_vm_to_thread
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

    #Reset the interpreter and the compiler.
    def reset
      interpreter_reset
      compiler_reset
    end

    #Connect the vm to a thread variable.
    def connect_vm_to_thread
      #Check for duplicates.
      current = Thread.current
      error "F91: Only one virtual machine allowed per thread" if current[:vm]

      #This virtual machine is associated with this thread.
      current[:vm] = self
      @start_time  = Time.now

      self
    end
  end

end
