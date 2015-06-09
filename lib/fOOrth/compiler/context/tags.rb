# coding: utf-8

#* compiler/context/tags.rb - Support tags in context.
module XfOOrth

  #* compiler/context/tags.rb - Support tags in context.
  class Context

    #Retrieve the data value currently in effect.
    def [](index)
      @data[index] || (previous && previous[index])
    end

    #Set a data value.
    def []=(index,value)
      @data[index] = value
    end

    #Get the compile tags in effect.
    def tags
      @data[:tags] || []
    end

    #Merge in a hash of tag data.
    def merge(new_data)
      @data.merge!(new_data)
    end

    #Validate a current data value.
    #<br>Parameters:
    #* symbol - The symbol of the value to be tested.
    #* expect - An array of valid values.
    #<br>Note:
    #* Throws a XfOOrthError if the value is not valid.
    #* To check for no value, use [nil] for expect.
    #* Returns true to facilitate testing only.
    def check_set(symbol, expect)
      current = self[symbol]

      unless expect.include?(current)
        error "F10: Found a #{current.inspect}, excpected #{expect}"
      end

      true
    end

  end
end
