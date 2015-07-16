# coding: utf-8

#* library/duration/intervals.rb - Duration intervals support library.
module XfOOrth

  #Intervals support for the \Duration class.
  class Duration

    #Seconds in a second.
    A_SECOND = 1.to_r

    #Seconds in a minute.
    A_MINUTE = (60 * A_SECOND).to_r

    #Seconds in an hour.
    AN_HOUR  = (60 * A_MINUTE).to_r

    #Seconds in a day.
    A_DAY    = (24 * AN_HOUR).to_r

    #Seconds in a (average) month.
    A_MONTH  = (Rational(365_2425, 120000) * A_DAY).to_r

    #Seconds in a (average) year.
    A_YEAR   = (12 * A_MONTH).to_r

    #An array of interval values.
    Intervals = [A_YEAR, A_MONTH, A_DAY, AN_HOUR, A_MINUTE, A_SECOND]

    #Find the largest interval for this duration
    def largest_interval
      (0..5).detect {|idx| Intervals[idx] <= period} || 5
    end

    #How many whole years in this duration?
    def years
      (@period/A_YEAR).to_i
    end

    #How many total years in this duration?
    def as_years
      (@period/A_YEAR).to_f
    end


    #How many months into the year in this duration?
    def months
      ((@period % A_YEAR)/A_MONTH).to_i
    end

    #How many total months in this duration?
    def as_months
      (@period/A_MONTH).to_f
    end


    #How many days into the month in this duration?
    def days
      ((@period % A_MONTH)/A_DAY).to_i
    end

    #How many total days in this duration?
    def as_days
      (@period/A_DAY).to_f
    end


    #How many hours into the day in this duration?
    def hours
      (((@period % A_MONTH) % A_DAY)/AN_HOUR).to_i
    end

    #How many total hours in this duration?
    def as_hours
      (@period/AN_HOUR).to_f
    end


    #How many minutes into the hour in this duration?
    def minutes
      (((@period % A_MONTH) % AN_HOUR)/A_MINUTE).to_i
    end

    #How many total minutes in this duration?
    def as_minutes
      (@period/A_MINUTE).to_f
    end


    #How many seconds into the minute in this duration?
    def seconds
      ((@period % A_MONTH) % A_MINUTE)
    end

    #How many total seconds in this duration?
    def as_seconds
      @period.to_f
    end

  end


  #Methods to retrieve interval values from the Duration class.

  #[Duration] .intervals [array]
  Duration.create_exclusive_method('.intervals', TosSpec, [], &lambda {|vm|
    vm.push(Duration::Intervals)
  })

  #[Duration] .sec_per_year [a_rational]
  Duration.create_exclusive_method('.sec_per_year', TosSpec, [], &lambda {|vm|
    vm.push(Duration::A_YEAR)
  })

  #[Duration] .sec_per_month [a_rational]
  Duration.create_exclusive_method('.sec_per_month', TosSpec, [], &lambda {|vm|
    vm.push(Duration::A_MONTH)
  })

  #[Duration] .sec_per_day [a_rational]
  Duration.create_exclusive_method('.sec_per_day', TosSpec, [], &lambda {|vm|
    vm.push(Duration::A_DAY)
  })

  #[Duration] .sec_per_hour [a_rational]
  Duration.create_exclusive_method('.sec_per_hour', TosSpec, [], &lambda {|vm|
    vm.push(Duration::AN_HOUR)
  })

  #[Duration] .sec_per_min [a_rational]
  Duration.create_exclusive_method('.sec_per_min', TosSpec, [], &lambda {|vm|
    vm.push(Duration::A_MINUTE)
  })

  #[Duration] .sec_per_sec [a_rational]
  Duration.create_exclusive_method('.sec_per_sec', TosSpec, [], &lambda {|vm|
    vm.push(Duration::A_SECOND)
  })


  #Methods to deal with intervals.

  #[a_duration] .largest_interval [an_index(0..5)]
  Duration.create_shared_method('.largest_interval', TosSpec, [], &lambda {|vm|
    vm.push(self.largest_interval)
  })


  #[a_duration] .years [an_integer]
  Duration.create_shared_method('.years', TosSpec, [], &lambda {|vm|
    vm.push(self.years)
  })

  #[a_duration] .as_years [a_float]
  Duration.create_shared_method('.as_years', TosSpec, [], &lambda {|vm|
    vm.push(self.as_years)
  })


  #[a_duration] .months [an_integer]
  Duration.create_shared_method('.months', TosSpec, [], &lambda {|vm|
    vm.push(self.months)
  })

  #[a_duration] .as_months [a_float]
  Duration.create_shared_method('.as_months', TosSpec, [], &lambda {|vm|
    vm.push(self.as_months)
  })


  #[a_duration] .days [an_integer]
  Duration.create_shared_method('.days', TosSpec, [], &lambda {|vm|
    vm.push(self.days)
  })

  #[a_duration] .as_days [a_float]
  Duration.create_shared_method('.as_days', TosSpec, [], &lambda {|vm|
    vm.push(self.as_days)
  })


  #[a_duration] .hours [an_integer]
  Duration.create_shared_method('.hours', TosSpec, [], &lambda {|vm|
    vm.push(self.hours)
  })

  #[a_duration] .as_hours [a_float]
  Duration.create_shared_method('.as_hours', TosSpec, [], &lambda {|vm|
    vm.push(self.as_hours)
  })


  #[a_duration] .minutes [an_integer]
  Duration.create_shared_method('.minutes', TosSpec, [], &lambda {|vm|
    vm.push(self.minutes)
  })

  #[a_duration] .as_minutes [a_float]
  Duration.create_shared_method('.as_minutes', TosSpec, [], &lambda {|vm|
    vm.push(self.as_minutes)
  })


  #[a_duration] .seconds [an_integer]
  Duration.create_shared_method('.seconds', TosSpec, [], &lambda {|vm|
    vm.push(self.seconds)
  })

  #[a_duration] .as_seconds [a_float]
  Duration.create_shared_method('.as_seconds', TosSpec, [], &lambda {|vm|
    vm.push(self.as_seconds)
  })



end
