# coding: utf-8

#Extensions to the \Float class required by the fOOrth language system.
class Float

  #Argument coercion methods.

  #Coerce the argument to match my type.
  def self.foorth_coerce(arg)
    Float(arg)
  rescue
    error "F40: Cannot coerce a #{arg.foorth_name} to a Float instance"
  end

  #Coerce the argument to match my type.
  def foorth_coerce(arg)
    Float(arg)
  rescue
    error "F40: Cannot coerce a #{arg.foorth_name} to a Float instance"
  end

end
