# coding: utf-8

#Extensions to the \Numeric class required by the fOOrth language system.
class Numeric
  #Convert this number to a form suitable for embedding in a source string.
  #<br>Returns
  #* An embeddable form of this number as a string.
  def embed
    self.to_s
  end

  #Convert this number to a fOOrth boolean.
  #<br>Endemic Code Smells
  # :reek:UncommunicativeMethodName
  def to_fOOrth_b
    self != 0
  end

  #Convert this number to a single character string.
  #<br>Endemic Code Smells
  # :reek:UncommunicativeMethodName
  def to_fOOrth_c
    as_int = self.to_i

    if as_int < 128
      as_int.chr.force_encoding("utf-8")
    else
      eval("\"\\u#{'%04X' % as_int}\"")
    end
  end

  #Convert this numeric to a numeric. Return self.
  #<br>Endemic Code Smells
  # :reek:UncommunicativeMethodName
  def to_fOOrth_n
    self
  end
end
