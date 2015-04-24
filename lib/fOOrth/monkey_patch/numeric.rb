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

    if as_int < 0 || as_int > 65535
      error "F40: Can't convert #{self} to a character."
    elsif as_int < 128
      as_int.chr.force_encoding("utf-8")
    else
      eval("\"\\u#{'%04X' % as_int}\"")
    end
  end

  #Convert this numeric to a numeric. Return self.
  def to_foorth_n
    self
  end

  #New comparison methods. The foorth_ prefix is short for min_max_.
  #These methods process and handle the special MaxNumeric and
  #MinNumeric modules.

  #The min max > operator
  def foorth_gt(other)
    self > foorth_coerce(other)
  end

  #The min max >= operator
  def foorth_ge(other)
    self >= foorth_coerce(other)
  end

  #The min max < operator
  def foorth_lt(other)
    self < foorth_coerce(other)
  end

  #The min max <= operator
  def foorth_le(other)
    self <= foorth_coerce(other)
  end

  #The min max <=> operator
  def foorth_cp(other)
    self <=> foorth_coerce(other)
  end

end
