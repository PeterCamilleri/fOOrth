# coding: utf-8

require_relative 'exclusive'
require_relative 'shared_cache'
require_relative 'method_missing'

#* core/object.rb - The generic object class of the fOOrth language system.
module XfOOrth

  #The \XObject class is basis for all fOOrth objects.
  class XObject
    include Exclusive
    extend  SharedCache
    include MethodMissing

    class << self

      #A class instance variable to get the \foorth_class of this object.
      attr_accessor :foorth_class

    end

    #Get the fOOrth class of this object.
    def foorth_class
      self.class.foorth_class
    end

    #Get the name of this object.
    def name
      "#{foorth_class.name} instance."
    end

  end
end
