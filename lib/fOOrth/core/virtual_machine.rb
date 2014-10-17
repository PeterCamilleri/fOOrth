# coding: utf-8

require_relative 'exclusive'
require_relative 'shared_cache'
require_relative 'method_missing'
require_relative 'shared'

#* core/virtual_machine.rb - The core connection to the virtual machine.
module XfOOrth

  #* core/virtual_machine.rb - The core connection to the virtual machine.
  class VirtualMachine
    include Exclusive
    extend  SharedCache
    include MethodMissing
    extend  Shared

    @instance_template = self

    #Class definitions stand in for the fOOrth virtual machine class.
    class << self
      #The fOOrth parent class of VirtualMachine is Object.
      def foorth_parent
        XfOOrth.object_class
      end

      #What foorth class is the virtual machine's class? For now we maintain
      #the illusion of normalcy by saying that it is the fOOrth Class class.
      def foorth_class
        XfOOrth.class_class
      end

      #The name of the virtual machine fOOrth class. We don't care if we
      #clobber the Ruby name.
      def name
        "VirtualMachine"
      end

      #Create a new fOOrth subclass of this class. This is not allowed for the
      #VirtualMachine class so this stub merely raises an exception.
      def create_foorth_subclass(_name)
        error "Forbidden operation: (VirtualMachine.create_foorth_subclass)."
      end
    end

    #Get the fOOrth class of this virtual machine
    def foorth_class
      VirtualMachine
    end

    #The name of the virtual machine instance
    def name
      "#{foorth_class.name} instance <#{@name}>."
    end
  end
end
