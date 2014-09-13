# coding: utf-8

#Extensions to the \Object class required by the foorth language system.
class Object
  #Raise a foorth language internal exception as this operation is not allowed.
  def embed
    error "Can't embed class #{self.class.to_s}"
  end

  #Convert this object to a foorth boolean.
  def to_foorth_b
    self
  end

  #Convert this object to a single character string.
  def to_foorth_c
    "\x00"
  end

  #Convert this object to a numeric. Returns nil for fail.
  def to_foorth_n
    nil
  end

  #Fail with XfoorthError argument error.
  def error(msg)
    fail Xfoorth::XfoorthError, msg, caller
  end

  #Raise an abort exception with message.
  def abort(msg)
    raise Xfoorth::ForceAbort, msg
  end

  #An alias for reading instance variables.
  alias :read_var  :instance_variable_get

  #An alias for writing instance variables.
  alias :write_var :instance_variable_set
end
