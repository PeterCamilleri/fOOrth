# coding: utf-8

#The largest possible negative numeric value.
class MinNumeric

  #Creating instances is not allowed.
  def initialize
    MinNumeric.invalid
  end

  class << self

    #That is NOT in my job description!
    def invalid
      error "Invalid operation for a min_num."
    end

    #Convert to a numeric. An error.
    alias to_foorth_n invalid

    #Convert to an integer. An error.
    alias to_i invalid

    #Convert to a string.
    def to_s
      "min_num"
    end

    #New math methods. The mnmx_ prefix is short for min_max_.
    #These methods process and handle the special MaxNumeric and
    #MinNumeric modules.

    #The min max > operator
    def mnmx_gt(_other)
      false
    end

    #The min max >= operator
    #<br>Endemic Code Smells
    #* :reek:FeatureEnvy
    def mnmx_ge(other)
      other == MinNumeric
    end

    #The min max < operator
    #<br>Endemic Code Smells
    #* :reek:FeatureEnvy
    def mnmx_lt(other)
      other != MinNumeric
    end

    #The min max <= operator
    def mnmx_le(_other)
      true
    end

    #The min max <=> operator
    #<br>Endemic Code Smells
    #* :reek:FeatureEnvy
    #* :reek:ControlParameter
    def mnmx_cp(other)
      other == MinNumeric ? 0 : -1
    end
  end

end
