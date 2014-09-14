# coding: utf-8

#Extensions to the \Complex class required by the fOOrth language system.
class Complex
  #Convert this complex number to a form suitable for embedding in a source string.
  #<br>Returns
  #* An embeddable form of this complex number as a string.
  def embed
    "Complex(#{self.real.embed},#{self.imaginary.embed})"
  end
end
