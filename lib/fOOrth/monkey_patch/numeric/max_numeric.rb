# coding: utf-8

module MaxNumeric

  class << self

    #A common bleat of complaint!
    def invalid
      error "Invalid operation for a max_num."
    end

    #Convert to a numeric. An error.
    alias to_foorth_n invalid

    #New math methods. The mnmx_ prefix is short for min_max_.
    #These methods process and handle the special MaxNumeric and
    #MinNumeric modules.

    #The min max > operator
    def mnmx_gt(other)
      other != MaxNumeric
    end



  end

end
