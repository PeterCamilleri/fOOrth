# coding: utf-8


#* modes.rb - The control of the various compiler modes.
module XfOOrth

  #* modes.rb - The control of the various compiler modes.
  class VirtualMachine

    #Ensure that the mode, control symbols, and nesting levels all agree
    #with the required values.
    #<br>Parameters
    #* modes - an array of the permissible operating modes.
    #* ctrls - an array of the allowed set of control values.
    def check_all(modes, ctrls)
      check_mode(modes)
      check, _temp, level = ctrl_peek
      check_ctrl(check, ctrls)
      check_level(level+1)
    end

    #Check that the compiler is in one of the expected modes.
    #<br>Parameters
    #* modes - an array of the permissible operating modes.
    def check_mode(modes)
      error "Compiler Mode Error: #{modes} vs #{@mode.inspect}" unless modes.include?(@mode)
    end

    #Check that the control symbol agrees with the expected value.
    #<br>Parameters
    #* check - the actual control value.
    #* ctrls - an array of the allowed set of control values.
    def check_ctrl(check, ctrls)
      error "Syntax Error #{ctrls} vs #{check}" unless ctrls.include?(check)
    end

    #Check that the nesting level agrees with the expected value.
    #<br>Parameters
    #* level - the computed nesting level, to be tested against
    #  the actual nesting level.
    def check_level(level)
      error "Nesting Error: #{@level} vs #{level}" if level != @level
    end

  end

end