# coding: utf-8

#* library/duration_library.rb - The duration support fOOrth library.
module XfOOrth

  #The duration class adds support for intervals of time that are not
  #directly associated with a date or time. Like 10 minutes as opposed
  #to July 4, 2015 5:43 PM.
  class Duration

    #Create a duration instance.
    #<br>Parameters
    #* period - The period of time of the duration.
    def initialize(period)
      @period = period
    end

    #Coerce the argument to match my type.
    def self.foorth_coerce(arg)
      Rational(arg)
    rescue
      error "F40: Cannot coerce a #{arg.foorth_name} to a Rational"
    end

    #Coerce the argument to match my type.
    def foorth_coerce(arg)
      Rational(arg)
    rescue
      error "F40: Cannot coerce a #{arg.foorth_name} to a Rational"
    end

    #Convert this duration to a rational number.
    def to_r
      @period
    end

    #Define equality for durations.
    def eql?(other)
      @period.eql?(XfOOrth.safe_rationalize(other))
    end

    #Alias to the standard operator.
    alias :== :eql?

    #Pass off all unknown methods to the period data.
    def method_missing(symbol, *args, &block)
      @period.send(symbol, *args, &block)
    end

  end

  #Connect the Duration class to the fOOrth class system
  Duration.create_foorth_proxy("Duration")

  #Stub out .new
  Duration.create_exclusive_method('.new', TosSpec, [:stub])

  #Helper Methods .to_d and .to_d!

  #[number] .to_d [a_duration]
  Object.create_shared_method('.to_d', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Duration.new(Rational(self)))
    rescue
      vm.push(nil)
    end
  })

  #[number] .to_d! [a_duration]
  Object.create_shared_method('.to_d!', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Duration.new(Rational(self)))
    rescue
      error "F40: Cannot convert #{self.to_s} to a Duration instance"
    end
  })

  #[a_duration] .to_d [a_duration]
  Duration.create_shared_method('.to_d', TosSpec, [], &lambda {|vm|
    begin
      vm.push(self)
    end
  })

  #[a_duration] .to_d! [a_duration]
  Duration.create_shared_method('.to_d!', TosSpec, [], &lambda {|vm|
    begin
      vm.push(self)
    end
  })


end
