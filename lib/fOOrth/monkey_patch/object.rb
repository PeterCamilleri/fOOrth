# coding: utf-8

#Extensions to the \Object class required by the fOOrth language system.
class Object

  #Raise a fOOrth language internal exception as this operation is not allowed.
  def foorth_embed
    error "Can't embed class #{self.class.to_s}"
  end

  #Convert this object to a fOOrth boolean.
  def to_foorth_b
    true
  end

  #Convert this object to a single character string.
  def to_foorth_c
    "\x00"
  end

  #Convert this object to a numeric. Returns nil for fail.
  def to_foorth_n
    nil
  end

  #Convert this object to a "pointer".
  def to_foorth_p
    [self]
  end

  #Fail with XfOOrthError argument error.
  def error(msg)
    fail XfOOrth::XfOOrthError, msg, caller
  end

  #Raise an abort exception with message.
  def abort(msg)
    raise XfOOrth::ForceAbort, msg
  end

  #Argument coercion methods. These are stubs.

  #Coerce the argument to match my type. Stub
  def foorth_coerce(_arg)
    error "Cannot coerce to a #{self.foorth_name}"
  end

  #Coerce the argument to match my type with min/max support. Stub
  def foorth_mnmx_coerce(_arg)
    error "Cannot min/max coerce to a #{self.foorth_name}"
  end


  #New math methods. The mnmx_ prefix is short for min_max_.
  #These methods handle the default case for non-numeric data.

  #The min max > operator
  def mnmx_gt(other)
    self > other
  end

  #The min max >= operator
  def mnmx_ge(other)
    self >= other
  end

  #The min max < operator
  def mnmx_lt(other)
    self < other
  end

  #The min max <= operator
  def mnmx_le(other)
    self <= other
  end

  #The min max <=> operator
  def mnmx_cp(other)
    self <=> other
  end

end
