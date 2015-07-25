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

  VirtualMachine.create_shared_method('local_offset', MacroSpec,
    [:macro, "vm.push(Time.now.utc_offset); "])


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
    vm.push(self.clone)
  })

  Time.create_shared_method('.to_t!', TosSpec, [], &lambda {|vm|
    vm.push(self.clone)
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
      error "F40: Cannot convert #{self.to_s} to a Time instance"
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

  #[a_time] .utc? [a boolean]
  Time.create_shared_method('.utc?', TosSpec, [], &lambda {|vm|
    vm.push(self.utc_offset == 0)
  })

  #[a_time] .as_utc [a_time]
  Time.create_shared_method('.as_utc', TosSpec, [], &lambda {|vm|
    vm.push(self.clone.localtime(0))
  })

  #[a_time] .as_local [a_time]
  Time.create_shared_method('.as_local', TosSpec, [], &lambda {|vm|
    vm.push(self.clone.localtime)
  })

  #[offset a_time] .as_zone [a_time]
  Time.create_shared_method('.as_zone', TosSpec, [], &lambda {|vm|
    offset = Integer.foorth_coerce(vm.pop)
    vm.push(self.clone.localtime(offset))
  })


  #Turn Time values to/from strings

  #[a_time] .time_s [string]
  Time.create_shared_method('.time_s', TosSpec, [], &lambda {|vm|
    vm.push(self.asctime)
  })

  format_action = lambda {|vm| vm.poke(self.strftime(vm.peek)); }

  # [a_time a_string] format [a_string]
  Time.create_shared_method('format', NosSpec, [], &format_action)

  # [a_time] f"string" [a_string]
  Time.create_shared_method('f"', NosSpec, [], &format_action)

  parse_action = lambda do |vm|
    fmt = vm.pop
    src = vm.pop

    begin
      vm.push(Time.strptime(src, fmt));
    rescue
      vm.push(nil)
    end
  end

  # [a_string Time a_string] parse [a_time or nil]
  Time.create_exclusive_method('parse', NosSpec, [], &parse_action)

  # [a_string Time] p"string" [a_time or nil]
  Time.create_exclusive_method('p"', NosSpec, [], &parse_action)

  parse_bang_action = lambda do |vm|
    fmt = vm.pop
    src = vm.pop

    begin
      vm.push(Time.strptime(src, fmt));
    rescue
      error "F40: Cannot parse \"#{src.to_s}\" into a Time instance"
    end
  end

  # [a_string Time a_string] parse [a_time or nil]
  Time.create_exclusive_method('parse!', NosSpec, [], &parse_bang_action)

  # [a_string Time] p"str" [a_time or nil]
  Time.create_exclusive_method('p!"', NosSpec, [], &parse_bang_action)


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

  #[a_time a_float] + [a_time]
  Time.create_shared_method('+', NosSpec, [], &lambda {|vm|
    begin
      other = vm.peek
      vm.poke(self + other.to_foorth_r)
    rescue TypeError
      error "F40: Unable to add a Time instance and a #{other.foorth_name}"
    end
  })

  #[a_time a_float] - [a_time]
  #[a_time a_time]  - [a_float]
  Time.create_shared_method('-', NosSpec, [], &lambda {|vm|
    begin
      other = vm.peek
      result = self - (other.is_a?(Time) ? other : other.to_foorth_r)
      vm.poke(result.is_a?(Time) ? result : Duration.new(result.rationalize))
    rescue TypeError
      error "F40: Unable to subtract a Time instance and a #{other.foorth_name}"
    end
  })

end
