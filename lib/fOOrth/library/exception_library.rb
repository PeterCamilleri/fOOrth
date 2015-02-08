# coding: utf-8

#* library/exception_library.rb - The exception system of the fOOrth library.
module XfOOrth

  #Connect the Exception class to the fOOrth class system.
  StandardError.create_foorth_proxy('Exception')


end

# Extensions to StandardError to support fOOrth.
class StandardError

  #A hash of exception classes and their fOOrth codes.
  FOORTH_EXCEPTION_CODE = {
    StandardError                               =>  "E",
      ArgumentError                             =>  "E010",
        Gem::Requirement::BadRequirementError   =>  "E010,010",
      EncodingError                             =>  "E020",
        Encoding::CompatibilityError            =>  "E020,010",
        Encoding::ConverterNotFoundError        =>  "E020,020",
        Encoding::InvalidByteSequenceError      =>  "E020,030",
        Encoding::UndefinedConversionError      =>  "E020,040",
      FiberError                                =>  "E030",
      IOError                                   =>  "E040",
        EOFError                                =>  "E040,010",
      IndexError                                =>  "E050",
        KeyError                                =>  "E050,010",
        StopIteration                           =>  "E050,020",
      LocalJumpError                            =>  "E060",
      Math::DomainError                         =>  "E070",
      NameError                                 =>  "E080",
        NoMethodError                           =>  "E080,010",
      RangeError                                =>  "E090",
        FloatDomainError                        =>  "E090,010",
      RegexpError                               =>  "E100",
      RuntimeError                              =>  "E110",
        Gem::Exception                          =>  "E110,010",
          Gem::CommandLineError                 =>  "E110,010,010",
          Gem::DependencyError                  =>  "E110,010,020",
          Gem::DependencyRemovalException       =>  "E110,010,030",
          Gem::DependencyResolutionError        =>  "E110,010,040",
          Gem::DocumentError                    =>  "E110,010,050",
          Gem::EndOfYAMLException               =>  "E110,010,060",
          Gem::FilePermissionError              =>  "E110,010,070",
          Gem::FormatException                  =>  "E110,010,080",
          Gem::GemNotFoundException             =>  "E110,010,090",
            Gem::SpecificGemNotFoundException   =>  "E110,010,090,010",
          Gem::GemNotInHomeException            =>  "E110,010,100",
          Gem::ImpossibleDependenciesError      =>  "E110,010,110",
          Gem::InstallError                     =>  "E110,010,120",
          Gem::InvalidSpecificationException    =>  "E110,010,130",
          Gem::OperationNotSupportedError       =>  "E110,010,140",
          Gem::RemoteError                      =>  "E110,010,150",
          Gem::RemoteInstallationCancelled      =>  "E110,010,160",
          Gem::RemoteInstallationSkipped        =>  "E110,010,170",
          Gem::RemoteSourceException            =>  "E110,010,180",
         #Gem::RubyVersionMismatch              =>  "E110,010,190",
          Gem::UnsatisfiableDependencyError     =>  "E110,010,200",
          Gem::VerificationError                =>  "E110,010,210",
     #SystemCallError                           =>  "E120,<error_name>",
      ThreadError                               =>  "E130",
      TypeError                                 =>  "E140",
      ZeroDivisionError                         =>  "E150"}

  if Object.const_defined?('RubyVersionMismatch')
    FOORTH_EXCEPTION_CODE[Gem::RubyVersionMismatch] = "E110,010,190"
  end

  #Retrieve the fOOrth exception code of this exception.
  def foorth_code
    klass = self.class

    until (result = FOORTH_EXCEPTION_CODE[klass])
      klass = klass.superclass
    end

    result
  end

  #Is this exception covered by target?
  def foorth_match(target)
    self.foorth_code[0, target.length] == target
  end

  #Get the name of this exception as seen in fOORth.
  def foorth_name
    "Exception instance <#{self.foorth_code}>"
  end

  #Get the error message for this exception.
  def foorth_message
    "#{self.foorth_code}: #{self.message}"
  end
end

# Extensions to SystemCallError to support fOOrth.
class SystemCallError

  #Get the fOOrth error code for a system call error.
  def foorth_code
    result = "E120"

    if /::/ =~ self.class.to_s
      result += ",#{$POSTMATCH}"
    end

    result
  end

end

#* library/exception_library.rb - XfOOrthError support of the fOOrth language.
module XfOOrth

  #* library/exception_library.rb - XfOOrthError support of the fOOrth language.
  class XfOOrthError < StandardError

    #Get the fOOrth error code for a fOOrth error.
    def foorth_code
      if /^[AF][\d,]+(?=:)/ =~ self.message
        $MATCH
      else
        "Fxxx"
      end
    end

    #Get the error message for this exception.
    def foorth_message
      self.message
    end

  end

end

module StandardError::Gem #:nodoc: don't document this
end