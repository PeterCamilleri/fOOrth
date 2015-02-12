# coding: utf-8

#* library/exception_library.rb - The exception system of the fOOrth library.
module XfOOrth

  #Connect the Exception class to the fOOrth class system.
  StandardError.create_foorth_proxy('Exception')


end

# A module of extensions to Exception classes to support fOOrth.
module XfOOrthExceptionExtensions

  #A hash of exception classes and their fOOrth codes.
  FOORTH_EXCEPTION_CODE = {
    SignalException                             =>  "S",
      Interrupt                                 =>  "S01",
    StandardError                               =>  "E",
      ArgumentError                             =>  "E01",
        Gem::Requirement::BadRequirementError   =>  "E01,01",
      EncodingError                             =>  "E02",
        Encoding::CompatibilityError            =>  "E02,01",
        Encoding::ConverterNotFoundError        =>  "E02,02",
        Encoding::InvalidByteSequenceError      =>  "E02,03",
        Encoding::UndefinedConversionError      =>  "E02,04",
      FiberError                                =>  "E03",
      IOError                                   =>  "E04",
        EOFError                                =>  "E04,01",
      IndexError                                =>  "E05",
        KeyError                                =>  "E05,01",
        StopIteration                           =>  "E05,02",
      LocalJumpError                            =>  "E06",
      Math::DomainError                         =>  "E07",
      NameError                                 =>  "E08",
        NoMethodError                           =>  "E08,01",
      RangeError                                =>  "E09",
        FloatDomainError                        =>  "E09,01",
      RegexpError                               =>  "E10",
      RuntimeError                              =>  "E11",
        Gem::Exception                          =>  "E11,01",
          Gem::CommandLineError                 =>  "E11,01,01",
          Gem::DependencyError                  =>  "E11,01,02",
          Gem::DependencyRemovalException       =>  "E11,01,03",
          Gem::DependencyResolutionError        =>  "E11,01,04",
          Gem::DocumentError                    =>  "E11,01,05",
          Gem::EndOfYAMLException               =>  "E11,01,06",
          Gem::FilePermissionError              =>  "E11,01,07",
          Gem::FormatException                  =>  "E11,01,08",
          Gem::GemNotFoundException             =>  "E11,01,09",
            Gem::SpecificGemNotFoundException   =>  "E11,01,09,01",
          Gem::GemNotInHomeException            =>  "E11,01,10",
          Gem::ImpossibleDependenciesError      =>  "E11,01,11",
          Gem::InstallError                     =>  "E11,01,12",
          Gem::InvalidSpecificationException    =>  "E11,01,13",
          Gem::OperationNotSupportedError       =>  "E11,01,14",
          Gem::RemoteError                      =>  "E11,01,15",
          Gem::RemoteInstallationCancelled      =>  "E11,01,16",
          Gem::RemoteInstallationSkipped        =>  "E11,01,17",
          Gem::RemoteSourceException            =>  "E11,01,18",
         #Gem::RubyVersionMismatch              =>  "E11,01,19",
          Gem::UnsatisfiableDependencyError     =>  "E11,01,20",
          Gem::VerificationError                =>  "E11,01,21",
     #SystemCallError                           =>  "E12,<error_name>",
      ThreadError                               =>  "E13",
      TypeError                                 =>  "E14",
      ZeroDivisionError                         =>  "E15"}

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

  #Get the name of this exception as seen in fOOrth.
  def foorth_name
    "Exception instance <#{self.foorth_code}>"
  end

  #Get the error message for this exception.
  def foorth_message
    "#{self.foorth_code}: #{self.message}"
  end
end

# Extensions from XfOOrthExceptionExtensions to StandardError to support fOOrth.
class StandardError
  include XfOOrthExceptionExtensions
end

# Extensions from XfOOrthExceptionExtensions to SignalException to support fOOrth.
class SignalException
  include XfOOrthExceptionExtensions
end

# Extensions to SystemCallError to support fOOrth.
class SystemCallError

  #Get the fOOrth error code for a system call error.
  def foorth_code
    result = "E12"

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

module XfOOrthExceptionExtensions::Gem #:nodoc: don't document this
end