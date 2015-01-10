# coding: utf-8

#Extensions to the \Object class required by the fOOrth language system.
class Integer

  #Argument coercion methods.

  #Coerce the argument to match my type.
  def foorth_coerce(arg)
    Integer(arg)
  rescue
    error "Cannot coerce a #{arg.foorth_name} to a #{self.foorth_name}"
  end

  #Coerce the argument to match my type with min/max support.
  def foorth_mnmx_coerce(arg)
    Integer(arg)
  rescue
    if arg == MaxNumeric
      MaxNumeric
    elsif arg == MinNumeric
      MinNumeric
    else
      error "Cannot coerce a #{arg.foorth_name} to a #{self.foorth_name}"
    end
  end


end
