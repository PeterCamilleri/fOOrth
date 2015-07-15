# coding: utf-8

#Extensions to the \Rational class required by the fOOrth language system.
class Rational
  #Convert this rational number to a form suitable for embedding in a source string.
  #<br>Returns
  #* An embeddable form of this rational number as a string.
  def foorth_embed
    "'#{self.to_s}'.to_r"
  end

  #Convert this object to a rational. Returns self.
  def to_foorth_r
    self
  end

  #Argument coercion methods.

  #Coerce the argument to match my type.
  def self.foorth_coerce(arg)
    arg.to_foorth_r || (error "F40: Cannot coerce a #{arg.foorth_name} to a Rational")
  end

  #Coerce the argument to match my type.
  def foorth_coerce(arg)
    arg.to_foorth_r || (error "F40: Cannot coerce a #{arg.foorth_name} to a Rational")
  end

end
