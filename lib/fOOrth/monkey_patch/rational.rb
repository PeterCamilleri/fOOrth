# coding: utf-8

#Extensions to the \Rational class required by the fOOrth language system.
class Rational
  #Convert this rational number to a form suitable for embedding in a source string.
  #<br>Returns
  #* An embeddable form of this rational number as a string.
  def foorth_embed
    "'#{self.to_s}'.to_r"
  end
end
