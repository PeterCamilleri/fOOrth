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
  #* :reek:FeatureEnvy -- false positive
  def foorth_coerce(arg)
    arg.to_s.freeze
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

  #Convert this string to a rational. Return a number or nil on fail.
  def to_foorth_r
    self.to_foorth_n.to_foorth_r
  end

  #A special patch for safe_clone
  def safe_clone
    self.freeze
  end

  #A special patch for full_clone
  def full_clone(_arg=nil)
    self.freeze
  end

  #Freeze only pure strings
  def foorth_string_freeze
    self.freeze
  end

end

#The \StringBuffer class is the mutable variant of the String class.
class StringBuffer < String

  #Create a string buffer from an object. Make sure that object is a
  #string and make sure that string is not frozen.
  def initialize(text)
    super(text)
  end

  #A special patch for safe_clone
  def safe_clone
    self.clone
  end

  #A special patch for full_clone
  def full_clone(_arg=nil)
    self.clone
  end

  #Freeze only pure strings
  def foorth_string_freeze
    self
  end

end
