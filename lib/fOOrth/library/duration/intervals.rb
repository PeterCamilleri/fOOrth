# coding: utf-8

#* library/duration/intervals.rb - Duration intervals support library.
module XfOOrth

  #Intervals support for the \Duration class.
  class Duration

    a_second = 1
    a_minute = 60 * a_second
    an_hour  = 60 * a_minute
    a_day    = 24 * an_hour
    a_month  = (365.2425/12.0) * a_day
    a_year   = 365.2425 * a_day

    @intervals = [a_year, a_month, a_day, an_hour, a_minute, a_second]

    class << self
      attr_reader :intervals
    end

  end

  Duration.create_exclusive_method('.intervals', TosSpec, [], &lambda {|vm|
    vm.push(intervals)
  })

end