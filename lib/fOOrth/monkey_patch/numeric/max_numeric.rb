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
    #<br>Endemic Code Smells
    #* :reek:FeatureEnvy
    def mnmx_gt(other)
      other != MaxNumeric
    end

    #The min max >= operator
    def mnmx_ge(_other)
      true
    end

    #The min max < operator
    def mnmx_lt(_other)
      false
    end

    #The min max <= operator
    #<br>Endemic Code Smells
    #* :reek:FeatureEnvy
    def mnmx_le(other)
      other == MaxNumeric
    end

    #The min max <=> operator
    #<br>Endemic Code Smells
    #* :reek:FeatureEnvy
    #* :reek:ControlParameter
    def mnmx_cp(other)
      other == MaxNumeric ? 0 : 1
    end
  end

end
