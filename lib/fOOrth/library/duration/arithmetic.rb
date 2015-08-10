# coding: utf-8

#* library/duration/arithmetic.rb - Arithmetic operator support for durations.
module XfOOrth

  #* library/duration/arithmetic.rb - Arithmetic operator support for durations.
  class Duration

    #Coerce the argument to match my type.
    def foorth_coerce(arg)
      @period.foorth_coerce(arg)
    end

    #Convert this duration to a rational number.
    def to_r
      @period
    end

    #Alias rationalize to the to_r method.
    alias :rationalize :to_r

    #Alias to_foorth_r to the to_r method.
    alias :to_foorth_r :to_r

    #Define equality for durations.
    def eql?(other)
      @period.eql?(other.to_foorth_r)
    end

    #Alias == to the eql? operator.
    alias :== :eql?
  end

  #[a_duration numeric/duration] + [a_duration]
  Duration.create_shared_method('+', NosSpec, [], &lambda {|vm|
    begin
      result = @period + @period.foorth_coerce(vm.peek)
      vm.poke(Duration.new(result))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  #[a_duration numeric/duration] - [a_duration]
  Duration.create_shared_method('-', NosSpec, [], &lambda {|vm|
    begin
      result = @period - @period.foorth_coerce(vm.peek)
      vm.poke(Duration.new(result))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  #[a_duration numeric/duration] * [a_duration]
  Duration.create_shared_method('*', NosSpec, [], &lambda {|vm|
    begin
      result = @period * @period.foorth_coerce(vm.peek)
      vm.poke(Duration.new(result))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  #[a_duration numeric/duration] / [a_duration]
  Duration.create_shared_method('/', NosSpec, [], &lambda {|vm|
    begin
      result = @period / @period.foorth_coerce(vm.peek)
      vm.poke(Duration.new(result))
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [a_duration] 1+ [a_duration+1]
  Duration.create_shared_method('1+', TosSpec, [], &lambda {|vm|
    result = @period + 1
    vm.push(Duration.new(result))
  })

  # [a_duration] 1- [a_duration-1]
  Duration.create_shared_method('1-', TosSpec, [], &lambda {|vm|
    result = @period - 1
    vm.push(Duration.new(result))
  })

  # [a_duration] 2+ [a_duration+2]
  Duration.create_shared_method('2+', TosSpec, [], &lambda {|vm|
    result = @period + 2
    vm.push(Duration.new(result))
  })

  # [a_duration] 2- [a_duration-2]
  Duration.create_shared_method('2-', TosSpec, [], &lambda {|vm|
    result = @period - 2
    vm.push(Duration.new(result))
  })

  # [a_duration] 2* [a_duration*2]
  Duration.create_shared_method('2*', TosSpec, [], &lambda {|vm|
    result = @period * 2
    vm.push(Duration.new(result))
  })

  # [a_duration] 2/ [a_duration/2]
  Duration.create_shared_method('2/', TosSpec, [], &lambda {|vm|
    result = @period / 2
    vm.push(Duration.new(result))
  })

end
