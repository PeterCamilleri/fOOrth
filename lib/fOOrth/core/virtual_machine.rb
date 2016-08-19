# coding: utf-8

#* core/virtual_machine.rb - The core connection to the virtual machine.
module XfOOrth

  #* core/virtual_machine.rb - The core connection to the virtual machine.
  class VirtualMachine

    #The name of the virtual machine instance
    def foorth_name
      "#{self.class.foorth_name} instance <#{@name}>"
    end

    #The currently active fiber, if any.
    attr_accessor :fiber

    class << self

      #Create a new fOOrth subclass of this class. This is not allowed for the
      #VirtualMachine class so this stub merely raises an exception.
      def create_foorth_subclass(_name)
        error "F13: Forbidden operation: VirtualMachine .class: "
      end

    end

  end
end
