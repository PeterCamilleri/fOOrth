# coding: utf-8

#* library/duration/intervals.rb - Duration intervals support library.
module XfOOrth

  #Intervals support for the \Duration class.
  class Duration

    A_Second = 1
    A_Minute = 60 * A_Second
    An_Hour  = 60 * A_Minute
    A_Day    = 24 * An_Hour
    A_Month  = Rational(365_2425, 120000) * A_Day
    A_Year   = Rational(365_2425, 10000) * A_Day

    Intervals = [A_Year, A_Month, A_Day, An_Hour, A_Minute, A_Second]

    #Find the largest interval for this duration
    def largest_interval
      (0..5).detect {|idx| Intervals[idx] <= period} || 5
    end

  end


  #Methods to retrieve interval values from the Duration class.

  Duration.create_exclusive_method('.intervals', TosSpec, [], &lambda {|vm|
    vm.push(Duration::Intervals)
  })

  Duration.create_exclusive_method('.sec_per_year', TosSpec, [], &lambda {|vm|
    vm.push(Duration::A_Year)
  })

  Duration.create_exclusive_method('.sec_per_month', TosSpec, [], &lambda {|vm|
    vm.push(Duration::A_Month)
  })

  Duration.create_exclusive_method('.sec_per_day', TosSpec, [], &lambda {|vm|
    vm.push(Duration::A_Day)
  })

  Duration.create_exclusive_method('.sec_per_hour', TosSpec, [], &lambda {|vm|
    vm.push(Duration::An_Hour)
  })

  Duration.create_exclusive_method('.sec_per_min', TosSpec, [], &lambda {|vm|
    vm.push(Duration::A_Minute)
  })

  Duration.create_exclusive_method('.sec_per_sec', TosSpec, [], &lambda {|vm|
    vm.push(Duration::A_Second)
  })


  #Methods to deal with intervals.

  #[a_duration] .largest_interval [an_index(0..5)]
  Duration.create_shared_method('.largest_interval', TosSpec, [], &lambda {|vm|
    vm.push(self.largest_interval)
  })

end
