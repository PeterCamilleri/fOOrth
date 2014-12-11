# coding: utf-8

module MinNumeric

  class << self

    #That is NOT in my job description!
    def invalid
      error "Invalid operation for a min_num."
    end

    #Convert to a numeric. An error.
    alias to_foorth_n invalid

    #New math methods. The mnmx_ prefix is short for min_max_.
    #These methods process and handle the special MaxNumeric and
    #MinNumeric modules.

    #The min max > operator
    def mnmx_gt(_other)
      false
    end


  end

end
