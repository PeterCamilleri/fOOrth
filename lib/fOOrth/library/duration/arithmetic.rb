# coding: utf-8

#* library/duration/arithmetic.rb - Arithmetic operator support for durations.
module XfOOrth

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
    result = @period + @period.foorth_coerce(vm.peek)
    vm.poke(Duration.new(result))
  })

  #[a_duration numeric/duration] - [a_duration]
  Duration.create_shared_method('-', NosSpec, [], &lambda {|vm|
    result = @period - @period.foorth_coerce(vm.peek)
    vm.poke(Duration.new(result))
  })

  #[a_duration numeric/duration] * [a_duration]
  Duration.create_shared_method('*', NosSpec, [], &lambda {|vm|
    result = @period * @period.foorth_coerce(vm.peek)
    vm.poke(Duration.new(result))
  })

  #[a_duration numeric/duration] / [a_duration]
  Duration.create_shared_method('/', NosSpec, [], &lambda {|vm|
    result = @period / @period.foorth_coerce(vm.peek)
    vm.poke(Duration.new(result))
  })

end