# coding: utf-8

#Extensions to the \Object class required by the fOOrth language system.
class Object

  #Raise a fOOrth language internal exception as this operation is not allowed.
  def foorth_embed
    error "Can't embed class #{self.class.to_s}"
  end

  #Convert this object to a fOOrth boolean.
  def to_foorth_b
    self ? true : false
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

  #An alias for reading instance variables.
  alias :read_var  :instance_variable_get

  #An alias for writing instance variables.
  alias :write_var :instance_variable_set
end
