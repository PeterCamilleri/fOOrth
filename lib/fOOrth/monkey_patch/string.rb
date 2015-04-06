# coding: utf-8

#Extensions to the \String class required by the fOOrth language system.
class String
  #Convert this String to a form suitable for embedding in a source string.
  #<br>Returns
  #* An embeddable form of this string as a string.
  def foorth_embed
    self.inspect
  end

  #Coerce the argument to match my type.
  #<br>Endemic Code Smells
  #* :reek:FeatureEnvy
  def foorth_coerce(arg)
    arg.to_s
  rescue
    error "F40: Cannot coerce a #{arg.foorth_name} to an String instance"
  end

  #Convert this string to a single character string.
  def to_foorth_c
    self[0]
  end

  #Convert this string to a numeric. Return a number or nil on fail.
  def to_foorth_n
    if /\di$/ =~ self      #Check for a trailing '<digit>i'.
      #Check for the internal '+' or '-'sign.
      if /(?<=\d)[+-]/ =~ self
        Complex(($PREMATCH).to_foorth_n, ($MATCH + $POSTMATCH).chop.to_foorth_n)
      else
        Complex(0, self.chop.to_foorth_n)
      end
    elsif /\d\/\d/ =~ self #Check for an embedded '<digit>/<digit>'.
      Rational(self)
    elsif /\d\.\d/ =~ self #Check for an embedded '<digit>.<digit>'.
      Float(self)
    else                   #For the rest, assume an integer.
      Integer(self)
    end
  rescue
    nil
  end

  #New comparison methods.

  #The min max > operator
  def mnmx_gt(other)
    self > other.to_s
  end

  #The min max >= operator
  def mnmx_ge(other)
    self >= other.to_s
  end

  #The min max < operator
  def mnmx_lt(other)
    self < other.to_s
  end

  #The min max <= operator
  def mnmx_le(other)
    self <= other.to_s
  end

  #The min max <=> operator
  def mnmx_cp(other)
    self <=> other.to_s
  end

end
