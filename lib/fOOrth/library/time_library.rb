# coding: utf-8

require 'time' # Get extended time support.

#* library/mutex_library.rb - The mutex support fOOrth library.
module XfOOrth

  #Connect the Mutex class to the fOOrth class system
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

  Time.create_shared_method('+', NosSpec, [], &lambda {|vm|
    begin
      other = vm.peek
      vm.poke(self + other)
    rescue TypeError
      error "F40: Unable to add a Time instance and a #{other.foorth_name}"
    end
  })

  Time.create_shared_method('-', NosSpec, [], &lambda {|vm|
    begin
      other = vm.peek
      vm.poke(self - other)
    rescue TypeError
      error "F40: Unable to subtract a Time instance and a #{other.foorth_name}"
    end
  })

end
