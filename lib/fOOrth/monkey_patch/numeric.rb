# coding: utf-8

require_relative 'numeric/max_numeric'
require_relative 'numeric/min_numeric'

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
    as_int = self.to_i

    if as_int < 128
      as_int.chr.force_encoding("utf-8")
    else
      eval("\"\\u#{'%04X' % as_int}\"")
    end
  end

  #Convert this numeric to a numeric. Return self.
  def to_foorth_n
    self
  end

  #New math methods. The mnmx_ prefix is short for min_max_.
  #These methods process and handle the special MaxNumeric and
  #MinNumeric modules.

  #The min max > operator
  def mnmx_gt(other)
    (other != MaxNumeric) && ((other == MinNumeric) || (self > other))
  end

  #The min max >= operator
  def mnmx_ge(other)
    (other != MaxNumeric) && ((other == MinNumeric) || (self >= other))
  end

  #The min max < operator
  def mnmx_lt(other)
    (other != MinNumeric) && ((other == MaxNumeric) || (self < other))
  end


end
