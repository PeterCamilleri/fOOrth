# coding: utf-8

#* library/duration/intervals.rb - Duration intervals support library.
module XfOOrth

  #Intervals support for the \Duration class.
  class Duration

    A_Second = 1
    A_Minute = 60 * A_Second
    An_Hour  = 60 * A_Minute
    A_Day    = 24 * An_Hour
    A_Month  = (365.2425/12.0) * A_Day
    A_Year   = 365.2425 * A_Day

    Intervals = [A_Year, A_Month, A_Day, An_Hour, A_Minute, A_Second]

  end

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

end
