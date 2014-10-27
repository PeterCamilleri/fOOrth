# coding: utf-8

#* compiler/pop_compile_class.rb - Pop a class argument for compile.
module XfOOrth

  #* compiler/pop_compile_class.rb - Pop a class argument for compile.
  class VirtualMachine
    #Pop the stack and verify that it is a fOOrth class.
    #<br>Parameters:
    #* operator - The name of the operator that requires the fOOrth class.
    #<br>Returns:
    #* A fOOrth class or raises an exception
    def pop_compile_class(operator)
      (result = pop).foorth_is_class?(self)
      error unless pop?
      result
    rescue
      error "The operand of #{operator} must be a class."
    end
  end

end