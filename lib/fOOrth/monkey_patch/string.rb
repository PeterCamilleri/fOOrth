# coding: utf-8

#Extensions to the \String class required by the fOOrth language system.
class String
  #Convert this String to a form suitable for embedding in a source string.
  #<br>Returns
  #* An embeddable form of this string as a string.
  def embed
    temp = (self.gsub(/"/)  {|_v| "\\\""}).gsub(/\\/) {|_v| "\\\\"}
    "\"#{temp}\""
  end

  #Convert this string to a fOOrth boolean.
  def to_foorth_b
    self != ''
  end

  #Convert this string to a single character string.
  def to_foorth_c
    self[0]
  end

  #Convert this string to a numeric. Return a number or nil on fail.
  def to_foorth_n
    if /\di$/ =~ self      #Check for a trailing '<digit>i'.
      if /(?<=\d)\+/ =~ self      #Check for the internal '+' sign.
        Complex(($`).to_foorth_n, ($').chop.to_foorth_n)
      elsif /(?<=\d)\-/ =~ self   #Check for the internal '-' sign.
        Complex(($`).to_foorth_n, -(($').chop.to_foorth_n))
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
end
