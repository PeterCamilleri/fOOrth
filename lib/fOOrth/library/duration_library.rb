# coding: utf-8

#* library/duration_library.rb - The duration support fOOrth library.
module XfOOrth

  #The duration class adds support for intervals of time that are not
  #directly associated with a date or time. Like 10 minutes as opposed
  #to July 4, 2015 5:43 PM.
  class Duration

    #The period of time (in seconds) contained in this duration.
    attr_accessor :period

    #Create a duration instance.
    #<br>Parameters
    #* period - The length of the duration.
    def initialize(period)
      @period = Float(period)
    end

  end

  #Connect the Duration class to the fOOrth class system
  Duration.create_foorth_proxy("Duration")

  #Stub out .new
  Duration.create_exclusive_method('.new', TosSpec, [:stub])



end
