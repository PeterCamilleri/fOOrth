# coding: utf-8

#* interpreter/data_stack.rb - The fOOrth language system data stack.
module XfOOrth

  #* interpreter/data_stack.rb - The fOOrth language system data stack.
  class VirtualMachine
    #The fOOrth data stack. This is the primary means used to hold data
    #for processing.
    attr_accessor :data_stack

    #Add an entry to the data stack.
    #<br>Parameters:
    #* datum - The data to be added to the data stack.
    def push(datum)
      @data_stack << datum
    end

    #Add some entries to the data stack.
    #<br>Parameters:
    #* datum - An array of data to be mass added to the data stack.
    def pushm(datum)
      @data_stack += datum
    end

    #Remove the "top" entry from the data stack.
    #<br>Returns:
    #* The "top" element of the data stack.
    #<br>Note:
    #* If the stack is empty this will raise an XfOOrthError exception.
    def pop
      error "F30: Data Stack Underflow: pop" if @data_stack.empty?
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
      begin
        error "F30: Data Stack Underflow: popm" if @data_stack.length < count
        @data_stack.pop(count)
      rescue
        @data_stack = []
        raise
      end
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
      unless @data_stack.length >= index && index > 0
        error "F30: Data Stack Underflow: peek"
      end

      @data_stack[-index]
    end

    #Overwrite the TOS with the supplied data.
    #<br>Parameters:
    #* datum - The data to be placed in the data stack.
    #<br>Note:
    #* Attempting to poke an empty stack will fail with an XfOOrthError exception.
    def poke(datum)
      error "F30: Data Stack Underflow: poke" if @data_stack.empty?
      @data_stack[-1] = datum
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

    #A special operation to support dyadic operators. Swap then pop.
    #<br>Returns:
    #* The second element from the data stack.
    #<br>Note:
    #* If the stack has less than 2 elements, this will raise an
    #  XfOOrthError exception.
    def swap_pop
      begin
        unless @data_stack.length >= 2
          error "F30: Data Stack Underflow: swap_pop"
        end

        nos, tos = @data_stack.pop(2)
        @data_stack << tos
        nos
      rescue
        @data_stack = []
        raise
      end
    end

  end
end
