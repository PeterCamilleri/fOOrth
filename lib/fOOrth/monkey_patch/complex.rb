# coding: utf-8

#Extensions to the \Complex class required by the fOOrth language system.
class Complex
  #Convert this complex number to a form suitable for embedding in a source string.
  #<br>Returns
  #* An embeddable form of this complex number as a string.
  def foorth_embed
    "Complex(#{self.real.foorth_embed},#{self.imaginary.foorth_embed})"
  end

  #Argument coercion methods.

  #Coerce the argument to match my type.
  def foorth_coerce(arg)
    Complex(arg)
  rescue
    error "F40: Cannot coerce a #{arg.foorth_name} to a Complex"
  end

  #Cannot convert this number to a single character string.
  def to_foorth_c
    error "F40: Cannot convert a Complex instance to a character"
  end

  #Cannot convert this number to a Rational.
  def to_foorth_r
    nil
  end
end
