# coding: utf-8

#* library/duration/make.rb - Support for duration constructor.
module XfOOrth

  class Duration
    #The length of time of the duration.
    attr_accessor :period

    #Create a duration instance.
    #<br>Parameters
    #* period - The period of time of the duration.
    def initialize(period)
      @period = period.rationalize
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
      vm.push(Duration.new(self))
    rescue
      vm.push(nil)
    end
  })

  #[number] .to_duration! [a_duration]
  Object.create_shared_method('.to_duration!', TosSpec, [], &lambda {|vm|
    begin
      vm.push(Duration.new(self))
    rescue
      error "F40: Cannot convert #{self.to_s} to a Duration instance"
    end
  })

  Array.create_shared_method('.to_duration', TosSpec, [], &lambda {|vm|
    begin
      result, interval = 0, Duration::INTERVALS.reverse_each
      self.reverse_each {|value| result += value * interval.next }
      vm.push(Duration.new(result))
    rescue
      vm.push(nil)
    end
  })

  Array.create_shared_method('.to_duration!', TosSpec, [], &lambda {|vm|
    begin
      result, interval = 0, Duration::INTERVALS.reverse_each
      self.reverse_each {|value| result += value * interval.next }
      vm.push(Duration.new(result))
    rescue
      error "F40: Cannot convert #{self.to_s} to a Duration instance"
    end
  })

  #[a_duration] .to_duration [a_duration]
  Duration.create_shared_method('.to_duration', TosSpec, [], &lambda {|vm|
      vm.push(self)
  })

  #[a_duration] .to_duration! [a_duration]
  Duration.create_shared_method('.to_duration!', TosSpec, [], &lambda {|vm|
      vm.push(self)
  })

end
