# coding: utf-8

#* interpreter/data_stack.rb - The fOOrth language system data stack.
module XfOOrth

  #* interpreter/data_stack.rb - The fOOrth language system data stack.
  class VirtualMachine
    #The fOOrth data stack. This is the primary means used to hold data
    #for processing.
    attr_reader :data_stack

    #Add an entry to the data stack.
    #<br>Parameters:
    #* datum - The data to be added to the data stack.
    def push(datum)
      @data_stack << datum
    end

    #Remove the "top" entry from the data stack.
    #<br>Returns:
    #* The "top" element of the data stack.
    #<br>Note:
    #* If the stack is empty this will raise an XfOOrthError exception.
    def pop
      unless @data_stack.length >= 1
        error "Data Stack Underflow: pop"
      end

      @data_stack.pop
    end

    #Remove multiple entries from the "top" of the data stack.
    #<br>Parameters:
    #* count - the number of elements to be returned.
    #<br>Returns:
    #* An array containing the "top" count elements of the data stack.
    #<br>Note:
    #* Raises an XfOOrthError exception if the stack has too few data.
    def popm(count)
      unless @data_stack.length >= count
        error "Data Stack Underflow: popm"
      end

      @data_stack.pop(count)
    end

    #Remove the "top" entry from the data stack as a boolean.
    #<br>Returns:
    #* The "top" element of the data stack as a boolean
    #<br>Note:
    #* If the stack is empty this will raise an XfOOrthError exception.
    def pop?
      pop.to_foorth_b
    end

    #Read an entry from the data stack without modify that stack.
    #<br>Parameters:
    #* index - The (optional) entry to be retrieved. 1 corresponds to the
    #  "top" of the stack, 2 the next element, etc.
    #  This parameter defaults to 1.
    #<br>Returns:
    #* The element specified from the data stack.
    #<br>Note:
    #* Attempting to access an element deeper than the number of elements
    #  on the stack will fail with an XfOOrthError exception.
    def peek(index=1)
      unless @data_stack.length >= index
        error "Data Stack Underflow: Peek"
      end

      @data_stack[-index]
    end

    #Read an entry from the data stack as a boolean without modify that stack.
    #<br>Parameters:
    #* index - The (optional) entry to be retrieved. 1 corresponds to the "top"
    #  of the stack, 2 the next element, etc. This parameter defaults to 1.
    #<br>Returns:
    #* The element specified from the data stack as a boolean.
    #<br>Note:
    #* Attempting to access an element deeper than the number of elements on
    #  the stack will fail with an XfOOrthError exception.
    def peek?(index=1)
      peek(index).to_foorth_b
    end
  end
end
