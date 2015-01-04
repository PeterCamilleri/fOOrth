# coding: utf-8

#* core/virtual_machine.rb - The core connection to the virtual machine.
module XfOOrth

  #* core/virtual_machine.rb - The core connection to the virtual machine.
  class VirtualMachine

    #The name of the virtual machine instance
    def foorth_name
      "VirtualMachine instance <#{@name}>"
    end

    class << self

      #The name of the virtual machine fOOrth class.
      def foorth_name
        "VirtualMachine"
      end

      #Create a new fOOrth subclass of this class. This is not allowed for the
      #VirtualMachine class so this stub merely raises an exception.
      def create_foorth_subclass(_name)
        error "Forbidden operation: (VirtualMachine.create_foorth_subclass)."
      end

    end

  end
end
