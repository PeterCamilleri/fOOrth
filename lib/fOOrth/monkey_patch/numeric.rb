# coding: utf-8

#Extensions to the \Numeric class required by the fOOrth language system.
class Numeric
  #Convert this number to a form suitable for embedding in a source string.
  #<br>Returns
  #* An embeddable form of this number as a string.
  def foorth_embed
    self.to_s
  end

  #Convert this number to a single character string.
  def to_foorth_c
    as_int = Integer.foorth_coerce(self)

    if as_int < 0 || as_int > 1114111
      error "F40: Can't convert #{self} to a character."
    else
      [as_int].pack('U')
    end
  end

  #Convert this numeric to a numeric. Return self.
  def to_foorth_n
    self
  end

  #Convert this numeric to a rational.
  def to_foorth_r
    self.rationalize
  end

end
