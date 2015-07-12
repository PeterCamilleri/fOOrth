# coding: utf-8

require_relative 'duration/intervals'
require_relative 'duration/formatter'

#* library/duration_library.rb - The duration support fOOrth library.
module XfOOrth

  #The duration class adds support for intervals of time that are not
  #directly associated with a date or time. Like 10 minutes as opposed
  #to July 4, 2015 5:43 PM.
  class Duration

    #The length of time of the duration.
    attr_reader :period

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

    #Convert this duration to an array
    def to_a
      temp = @period

      Duration::Intervals.map do |interval|
        value = (temp / interval).to_i
        temp -= value * interval
        value
      end

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

  #Helper Methods .to_duration and .to_duration!

  #[number] .to_duration [a_duration]
  Object.create_shared_method('.to_duration', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Duration.new(Rational(self)))
    rescue
      vm.push(nil)
    end
  })

  #[number] .to_duration! [a_duration]
  Object.create_shared_method('.to_duration!', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Duration.new(Rational(self)))
    rescue
      error "F40: Cannot convert #{self.to_s} to a Duration instance"
    end
  })

  Array.create_shared_method('.to_duration', TosSpec, [], &lambda {|vm|
    begin
      result, interval = 0, Duration::Intervals.reverse_each
      self.reverse_each {|value| result += value * interval.next }
      vm.push(Duration.new(result))
    rescue
      vm.push(nil)
    end
  })

  Array.create_shared_method('.to_duration!', TosSpec, [], &lambda {|vm|
    begin
      result, interval = 0, Duration::Intervals.reverse_each
      self.reverse_each {|value| result += value * interval.next }
      vm.push(Duration.new(result))
    rescue
      error "F40: Cannot convert #{self.to_s} to a Duration instance"
    end
  })

  #[a_duration] .to_duration [a_duration]
  Duration.create_shared_method('.to_duration', TosSpec, [], &lambda {|vm|
    begin
      vm.push(self)
    end
  })

  #[a_duration] .to_duration! [a_duration]
  Duration.create_shared_method('.to_duration!', TosSpec, [], &lambda {|vm|
    begin
      vm.push(self)
    end
  })

  #[a_duration] .to_a [an_array]
  Duration.create_shared_method('.to_a', TosSpec, [], &lambda{|vm|
    vm.push(self.to_a)
  })

  #Default conversion to string. See duration/formatter for formatted output.
  Duration.create_shared_method('.to_s', TosSpec, [], &lambda {|vm|
    vm.push("Duration instance <#{self.period.to_f} seconds>" )
  })

end
