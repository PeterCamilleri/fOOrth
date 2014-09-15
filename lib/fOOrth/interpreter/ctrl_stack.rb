# coding: utf-8

#* interpreter/ctrl_stack.rb - The fOOrth language system ctrl stack.
module XfOOrth

  #* interpreter/ctrl_stack.rb - The fOOrth language system ctrl stack.
  class VirtualMachine
    #The fOOrth control stack. This is mostly used to hold information
    #relating to control structures during compile and interpretation.
    attr_reader :ctrl_stack

    #Add an entry to the ctrl stack.
    #<br>Parameters:
    #* datum - The data to be added to the ctrl stack.
    def ctrl_push(datum)
      @ctrl_stack << datum
    end

    #Remove the "top" entry from the ctrl stack.
    #<br>Returns:
    #* The "top" element of the ctrl stack.
    #<br>Note:
    #* If the stack is empty this will raise a XfOOrthError exception.
    def ctrl_pop
      unless @ctrl_stack.length >= 1
        error "Control Stack Underflow: pop"
      end

      @ctrl_stack.pop
    end

    #Read an entry from the ctrl stack without modify that stack.
    #<br>Parameters:
    #* index - The (optional) entry to be retrieved. 1 corresponds to the
    #  "top" of the stack, 2 the next element, etc.
    #  This parameter defaults to 1.
    #<br>Returns:
    #* The element specified from the ctrl stack.
    #<br>Note:
    #* Attempting to access an element deeper than the number of elements
    #  on the stack will fail with an XfOOrthError exception.
    def ctrl_peek(index=1)
      unless @ctrl_stack.length >= index
        error "Control Stack Underflow: Peek"
      end

      @ctrl_stack[-index]
    end

  end

end