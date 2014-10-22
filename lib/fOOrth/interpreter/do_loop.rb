# coding: utf-8

#* do_loop.rb - The fOOrth language do loop support module.
module XfOOrth

  #* interpreter/do_loop.rb - The fOOrth language do loop support module.
  class VirtualMachine

    #The runtime implementation of the "do" word.
    #<br>Parameters:
    #* jloop - An optional outer loop value.
    #* block - A block of code to be executed as the do loop body.
    #<br>Block Parameters:
    #* iloop - The stack frame of the current loop counter. This
    #  corresponds to the fOOrth 'i' value.
    #* jloop - The stack frame of any containing loop counter. This corresponds
    #  to the fOOrth 'j' value. If there is no containing loop, this
    #  will always be a zero frame ie: [0, 0, 0].
    #<br>Note:
    #* Nested loops must be in the same compiler context in order to use this
    #  mechanism. Otherwise, loop index counters must be passed in explicitly.
    #<br>Endemic Code Smells
    #* :reek:FeatureEnvy
    def vm_do(jloop = [0, 0, 0], &block)
      #Pop the start and ending values from the stack.
      start_index, end_index = popm(2)

      #Construct the loop data frame.
      iloop = [start_index, end_index - 1, start_index + end_index - 1]

      #Loop until done!
      while iloop[0] <= iloop[1]
        yield iloop, jloop
      end
    end

  end

end
