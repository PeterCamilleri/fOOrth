# coding: utf-8

#Extensions to the \TrueClass class required by the fOOrth language system.
class TrueClass

  #Convert this object to a fOOrth boolean.
  def to_foorth_b
    self
  end

  #Convert this object to a form suitable for embedding in a source string.
  #<br>Returns
  #* An embeddable form of this object as a string.
  def foorth_embed
    'true'
  end

end
