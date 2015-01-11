# coding: utf-8

#Extensions to the \Integer class required by the fOOrth language system.
class Integer

  #Argument coercion methods.

  #Coerce the argument to match my type.
  def self.foorth_coerce(arg)
    Integer(arg)
  rescue
    error "Cannot coerce a #{arg.foorth_name} to an Integer instance"
  end

  #Coerce the argument to match my type.
  def foorth_coerce(arg)
    Integer(arg)
  rescue
    error "Cannot coerce a #{arg.foorth_name} to an Integer instance"
  end

end
