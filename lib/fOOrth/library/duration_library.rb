# coding: utf-8

require_relative 'duration/make'
require_relative 'duration/arithmetic'
require_relative 'duration/intervals'
require_relative 'duration/formatter'

#* library/duration_library.rb - The duration support fOOrth library.
module XfOOrth

  #The duration class adds support for intervals of time that are not
  #directly associated with a date or time. Like 10 minutes as opposed
  #to July 4, 2015 5:43 PM.
  class Duration

    #Convert this duration to an array.
    #<br>Endemic Code Smells
    #* :reek:FeatureEnvy -- false positive.
    def to_a
      balance = @period

      Duration::INTERVALS.map do |interval|
        if interval > A_SECOND
          value = (balance / interval).to_i
          balance -= value * interval
          value
        else
          balance.to_f
        end
      end

    end

    #Pass off all unknown methods to the period data.
    def method_missing(symbol, *args, &block)
      @period.send(symbol, *args, &block)
    end

  end

  #[a_duration] .to_a [an_array]
  Duration.create_shared_method('.to_a', TosSpec, [], &lambda{|vm|
    vm.push(self.to_a)
  })

  #Default conversion to string. See duration/formatter for formatted output.
  Duration.create_shared_method('.to_s', TosSpec, [], &lambda {|vm|
    vm.push("Duration instance <#{self.period.to_f} seconds>" )
  })
end
