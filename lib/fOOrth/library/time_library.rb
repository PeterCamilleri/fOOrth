# coding: utf-8

require 'time' # Get extended time support.

#* library/time_library.rb - The time support fOOrth library.
module XfOOrth

  #Connect the Time class to the fOOrth class system
  Time.create_foorth_proxy

  #Class Methods

  #Stub out .new
  Time.create_exclusive_method('.new', TosSpec, [:stub])

  # [] now [Time.now]
  VirtualMachine.create_shared_method('now', MacroSpec,
    [:macro, "vm.push(Time.now); "])

  #Instance Methods

  #Helper Methods .to_t and .to_t!

  #[object] .to_t [a_time]
  Numeric.create_shared_method('.to_t', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Time.at(self))
    rescue
      vm.push(nil)
    end
  })

  Numeric.create_shared_method('.to_t!', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Time.at(self))
    rescue
      error "F40: Cannot convert #{self.to_s} to a Time instance"
    end
  })

  Complex.create_shared_method('.to_t',  TosSpec, [:stub])
  Complex.create_shared_method('.to_t!', TosSpec, [:stub])

  String.create_shared_method('.to_t', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Time.parse(self))
    rescue
      vm.push(nil)
    end
  })

  String.create_shared_method('.to_t!', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Time.parse(self))
    rescue
      error "F40: Cannot convert \"#{self.to_s}\" to a Time instance"
    end
  })

  Time.create_shared_method('.to_t', TosSpec, [], &lambda {|vm|
    vm.push(self)
  })

  Time.create_shared_method('.to_t!', TosSpec, [], &lambda {|vm|
    vm.push(self)
  })

  Array.create_shared_method('.to_t', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Time.new(*self))
    rescue
      vm.push(nil)
    end
  })

  Array.create_shared_method('.to_t!', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Time.new(*self))
    rescue
      error "F40: Cannot convert \"#{self.to_s}\" to a Time instance"
    end
  })


  #Turn a Time value into an Array

  #[time] .to_a [string]
  Time.create_shared_method('.to_a', TosSpec, [], &lambda {|vm|
    vm.push([self.year,
             self.month,
             self.day,
             self.hour,
             self.min,
             self.sec + self.subsec.to_f,
             self.utc_offset])
  })


  #Methods to access various attributes of a Time object.

  Time.create_shared_method('.year', TosSpec, [], &lambda {|vm|
    vm.push(self.year)
  })

  Time.create_shared_method('.month', TosSpec, [], &lambda {|vm|
    vm.push(self.month)
  })

  Time.create_shared_method('.day', TosSpec, [], &lambda {|vm|
    vm.push(self.day)
  })

  Time.create_shared_method('.hour', TosSpec, [], &lambda {|vm|
    vm.push(self.hour)
  })

  Time.create_shared_method('.minute', TosSpec, [], &lambda {|vm|
    vm.push(self.min)
  })

  Time.create_shared_method('.second', TosSpec, [], &lambda {|vm|
    vm.push(self.sec)
  })

  Time.create_shared_method('.fraction', TosSpec, [], &lambda {|vm|
    vm.push(self.subsec.to_f)
  })

  Time.create_shared_method('.sec_frac', TosSpec, [], &lambda {|vm|
    vm.push(self.sec + self.subsec.to_f)
  })

  Time.create_shared_method('.offset', TosSpec, [], &lambda {|vm|
    vm.push(self.utc_offset)
  })


  #Time zone control

  #[time] .utc? [a boolean]
  Time.create_shared_method('.utc?', TosSpec, [], &lambda {|vm|
    vm.push(self.utc_offset == 0)
  })

  #[time] .as_utc [time]
  Time.create_shared_method('.as_utc', TosSpec, [], &lambda {|vm|
    vm.push(self.localtime(0))
  })

  #[time] .as_local [time]
  Time.create_shared_method('.as_local', TosSpec, [], &lambda {|vm|
    vm.push(self.localtime)
  })

  #[offset time] .with_offset [time]
  Time.create_shared_method('.with_offset', TosSpec, [], &lambda {|vm|
    offset = Integer.foorth_coerce(vm.pop)
    vm.push(self.localtime(offset))
  })


  #Turn Time values into strings

  #[time] .time_s [string]
  Time.create_shared_method('.time_s', TosSpec, [], &lambda {|vm|
    vm.push(self.asctime)
  })

  format_action = lambda {|vm| vm.poke(self.strftime(vm.peek)); }

  # [a_str] format ['a formatted string']
  Time.create_shared_method('format', NosSpec, [], &format_action)

  # [a] f"str" ['a formatted string']
  Time.create_shared_method('f"', NosSpec, [], &format_action)


  #Time comparison operations

  Time.create_shared_method('>', NosSpec, [], &lambda {|vm|
    vm.poke(self.to_f > Float.foorth_coerce(vm.peek))
  })

  Time.create_shared_method('>=', NosSpec, [], &lambda {|vm|
    vm.poke(self.to_f >= Float.foorth_coerce(vm.peek))
  })

  Time.create_shared_method('<', NosSpec, [], &lambda {|vm|
    vm.poke(self.to_f < Float.foorth_coerce(vm.peek))
  })

  Time.create_shared_method('<=', NosSpec, [], &lambda {|vm|
    vm.poke(self.to_f <= Float.foorth_coerce(vm.peek))
  })

  Time.create_shared_method('<=>', NosSpec, [], &lambda {|vm|
    vm.poke(self.to_f <=> Float.foorth_coerce(vm.peek))
  })

  #Temporal mathematics, no Tardis required.

  #[time float] + [time]
  Time.create_shared_method('+', NosSpec, [], &lambda {|vm|
    begin
      other = vm.peek
      vm.poke(self + other)
    rescue TypeError
      error "F40: Unable to add a Time instance and a #{other.foorth_name}"
    end
  })

  #[time float] - [time]
  #[time time]  - [float]
  Time.create_shared_method('-', NosSpec, [], &lambda {|vm|
    begin
      other = vm.peek
      vm.poke(self - other)
    rescue TypeError
      error "F40: Unable to subtract a Time instance and a #{other.foorth_name}"
    end
  })

end
