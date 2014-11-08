# coding: utf-8

#Extensions to the \Class class required by the fOOrth language system.
# coding: utf-8

#Extensions to the \Object class required by the fOOrth language system.
class Class

  #Get the foorth name of this class. Note: test located in object_tests.rb
  def foorth_name
    "Ruby::#{self.name}"
  end

end
