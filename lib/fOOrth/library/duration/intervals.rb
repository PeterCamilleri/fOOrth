# coding: utf-8

#* library/duration/intervals.rb - Duration intervals support library.
module XfOOrth

  #Intervals support for the \Duration class.
  class Duration

    #Seconds in a second.
    A_SECOND = Duration.new(1.to_r)

    #Seconds in a minute.
    A_MINUTE = Duration.new(60 * A_SECOND.to_r)

    #Seconds in an hour.
    AN_HOUR  = Duration.new(60 * A_MINUTE.to_r)

    #Seconds in a day.
    A_DAY    = Duration.new(24 * AN_HOUR.to_r)

    #Seconds in a (average) month.
    A_MONTH  = Duration.new(Rational(365_2425, 120000) * A_DAY.to_r)

    #Seconds in a (average) year.
    A_YEAR   = Duration.new(12 * A_MONTH.to_r)

    #An array of interval values.
    INTERVALS = [A_YEAR, A_MONTH, A_DAY, AN_HOUR, A_MINUTE, A_SECOND]

    #An array of interval labels.
    LABELS = ["years", "months", "days", "hours", "minutes", "seconds"]

    #Pick the appropriate label
    #<br>Endemic Code Smells
    #* :reek:ControlParameter
    def self.pick_label(index, qty=1)
      result = LABELS[index]
      result = result.chop if qty == 1
      " " + result
    end

    #Find the largest interval for this duration
    def largest_interval
      (0..5).detect {|idx| INTERVALS[idx] <= period} || 5
    end

    #How many whole years in this duration?
    def years
      (@period/A_YEAR.to_r).to_i
    end

    #How many total years in this duration?
    def as_years
      (@period/A_YEAR.to_r).to_f
    end


    #How many months into the year in this duration?
    def months
      ((@period % A_YEAR.to_r)/A_MONTH.to_r).to_i
    end

    #How many total months in this duration?
    def as_months
      (@period/A_MONTH.to_r).to_f
    end


    #How many days into the month in this duration?
    def days
      ((@period % A_MONTH.to_r)/A_DAY.to_r).to_i
    end

    #How many total days in this duration?
    def as_days
      (@period/A_DAY.to_r).to_f
    end


    #How many hours into the day in this duration?
    def hours
      (((@period % A_MONTH.to_r) % A_DAY.to_r)/AN_HOUR.to_r).to_i
    end

    #How many total hours in this duration?
    def as_hours
      (@period/AN_HOUR.to_r).to_f
    end


    #How many minutes into the hour in this duration?
    def minutes
      (((@period % A_MONTH.to_r) % AN_HOUR.to_r)/A_MINUTE.to_r).to_i
    end

    #How many total minutes in this duration?
    def as_minutes
      (@period/A_MINUTE.to_r).to_f
    end


    #How many seconds into the minute in this duration?
    def seconds
      ((@period % A_MONTH.to_r) % A_MINUTE.to_f)
    end

    #How many total seconds in this duration?
    def as_seconds
      @period.to_f
    end

  end


  #Methods to retrieve interval values from the Duration class.

  #[Duration] .intervals [array]
  Duration.create_exclusive_method('.intervals', TosSpec, [], &lambda {|vm|
    vm.push(Duration::INTERVALS)
  })

  #[Duration] .labels [array]
  Duration.create_exclusive_method('.labels', TosSpec, [], &lambda {|vm|
    vm.push(Duration::LABELS)
  })

  #[] a_year [a_duration]
  VirtualMachine.create_shared_method('a_year', VmSpec, [], &lambda {|vm|
    vm.push(Duration::A_YEAR)
  })

  #[] a_month [a_duration]
  VirtualMachine.create_shared_method('a_month', VmSpec, [], &lambda {|vm|
    vm.push(Duration::A_MONTH)
  })

  #[] a_day [a_duration]
  VirtualMachine.create_shared_method('a_day', VmSpec, [], &lambda {|vm|
    vm.push(Duration::A_DAY)
  })

  #[] an_hour [a_duration]
  VirtualMachine.create_shared_method('an_hour', VmSpec, [], &lambda {|vm|
    vm.push(Duration::AN_HOUR)
  })

  #[] a_minute [a_duration]
  VirtualMachine.create_shared_method('a_minute', VmSpec, [], &lambda {|vm|
    vm.push(Duration::A_MINUTE)
  })

  #[] a_second [a_duration]
  VirtualMachine.create_shared_method('a_second', VmSpec, [], &lambda {|vm|
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
