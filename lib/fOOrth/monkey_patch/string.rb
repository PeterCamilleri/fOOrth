# coding: utf-8

#Extensions to the \String class required by the fOOrth language system.
class String
  #Convert this String to a form suitable for embedding in a source string.
  #<br>Returns
  #* An embeddable form of this string as a string.
  #<br>Note:
  #* The strings involved go through several layers of quote processing. The
  #  resulting code is most entertaining!
  def embed
    "'#{self.gsub(/\\/, "\\\\").gsub(/'/,  "\\\\'")}'"
  end

  #Convert this string to a fOOrth boolean.
  #<br>Endemic Code Smells
  # :reek:UncommunicativeMethodName
  def to_fOOrth_b
    self != ''
  end

  #Convert this string to a single character string.
  #<br>Endemic Code Smells
  # :reek:UncommunicativeMethodName
  def to_fOOrth_c
    self[0]
  end

  #Convert this string to a numeric. Return a number or nil on fail.
  #<br>Endemic Code Smells
  # :reek:UncommunicativeMethodName
  def to_fOOrth_n
    if /\di$/ =~ self      #Check for a trailing '<digit>i'.
      if /\+/ =~ self      #Check for the internal '+' sign.
        Complex(($`).to_fOOrth_n, ($').chop.to_fOOrth_n)
      else
        Complex(0, self.chop.to_fOOrth_n)
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
end
