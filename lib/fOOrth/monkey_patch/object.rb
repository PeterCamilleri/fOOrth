# coding: utf-8

#Extensions to the \Object class required by the fOOrth language system.
class Object

  #Raise a fOOrth language internal exception as this operation is not allowed.
  def foorth_embed
    error "F40: Can't embed class #{self.class.foorth_class_name}"
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

  #Convert this object to a rational. Returns nil for fail.
  def to_foorth_r
    nil
  end

  #Freeze only pure strings
  def foorth_string_freeze
    self
  end

  #Fail with XfOOrthError argument error.
  def error(msg)
    fail XfOOrth::XfOOrthError, msg, caller
  end

  #A helper macro for method not understood errors.
  def f20_error(recvr, name, symbol)
    fail XfOOrth::XfOOrthError,
         "F20: A #{recvr.foorth_name} does not understand #{name} (#{symbol.inspect}).",
         caller
  end

  #Argument coercion methods. These are stubs.

  #Coerce the argument to match my type. Stub
  def foorth_coerce(_arg)
    error "F40: Cannot coerce to a #{self.foorth_name}"
  end

end
