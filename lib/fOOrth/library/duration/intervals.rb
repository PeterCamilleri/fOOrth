# coding: utf-8

#* library/duration/intervals.rb - Duration intervals support library.
module XfOOrth

  #Intervals support for the \Duration class.
  class Duration

    A_SECOND = 1
    A_MINUTE = 60 * A_SECOND
    AN_HOUR  = 60 * A_MINUTE
    A_DAY    = 24 * AN_HOUR
    A_MONTH  = Rational(365_2425, 120000) * A_DAY
    A_YEAR   = 12 * A_MONTH

    Intervals = [A_YEAR, A_MONTH, A_DAY, AN_HOUR, A_MINUTE, A_SECOND]

    #Find the largest interval for this duration
    def largest_interval
      (0..5).detect {|idx| Intervals[idx] <= period} || 5
    end

    #How many years in this duration?
    def years
      (@period/A_YEAR).to_i
    end

    #How many months in this duration?
    def months
      ((@period - (@period/A_YEAR).to_i*A_YEAR)/A_MONTH).to_i
    end

    #How many days in this duration?
    def days
      self.to_a[2]
    end

    #How many hours in this duration?
    def hours
      self.to_a[3]
    end

    #How many minutes in this duration?
    def minutes
      self.to_a[4]
    end

    #How many seconds in this duration?
    def seconds
      self.to_a[5]
    end

  end


  #Methods to retrieve interval values from the Duration class.

  Duration.create_exclusive_method('.intervals', TosSpec, [], &lambda {|vm|
    vm.push(Duration::Intervals)
  })

  Duration.create_exclusive_method('.sec_per_year', TosSpec, [], &lambda {|vm|
    vm.push(Duration::A_YEAR)
  })

  Duration.create_exclusive_method('.sec_per_month', TosSpec, [], &lambda {|vm|
    vm.push(Duration::A_MONTH)
  })

  Duration.create_exclusive_method('.sec_per_day', TosSpec, [], &lambda {|vm|
    vm.push(Duration::A_DAY)
  })

  Duration.create_exclusive_method('.sec_per_hour', TosSpec, [], &lambda {|vm|
    vm.push(Duration::AN_HOUR)
  })

  Duration.create_exclusive_method('.sec_per_min', TosSpec, [], &lambda {|vm|
    vm.push(Duration::A_MINUTE)
  })

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

  #[a_duration] .months [an_integer]
  Duration.create_shared_method('.months', TosSpec, [], &lambda {|vm|
    vm.push(self.months)
  })

  #[a_duration] .days [an_integer]
  Duration.create_shared_method('.days', TosSpec, [], &lambda {|vm|
    vm.push(self.days)
  })

  #[a_duration] .hours [an_integer]
  Duration.create_shared_method('.hours', TosSpec, [], &lambda {|vm|
    vm.push(self.hours)
  })

  #[a_duration] .minutes [an_integer]
  Duration.create_shared_method('.minutes', TosSpec, [], &lambda {|vm|
    vm.push(self.minutes)
  })

  #[a_duration] .seconds [an_integer]
  Duration.create_shared_method('.seconds', TosSpec, [], &lambda {|vm|
    vm.push(self.seconds)
  })


end
