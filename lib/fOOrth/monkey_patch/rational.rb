# coding: utf-8

#Extensions to the \Rational class required by the fOOrth language system.
class Rational
  #Convert this rational number to a form suitable for embedding in a source string.
  #<br>Returns
  #* An embeddable form of this rational number as a string.
  def foorth_embed
    "'#{self.to_s}'.to_r"
  end

  #Argument coercion methods.

  #Coerce the argument to match my type.
  def foorth_coerce(arg)
    Rational(arg)
  rescue
    error "Cannot coerce a #{arg.foorth_name} to a #{self.foorth_name}"
  end

  #Coerce the argument to match my type with min/max support.
  def foorth_mnmx_coerce(arg)
    Rational(arg)
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
