# coding: utf-8

module MaxNumeric

  class << self

    #A common bleat of complaint!
    def invalid
      error "Invalid operation for a max_num."
    end

    #Convert to a numeric. An error.
    alias to_foorth_n invalid




  end

end
