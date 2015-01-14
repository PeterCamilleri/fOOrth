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
    error "Cannot coerce a #{arg.foorth_name} to a Complex"
  end

end
