# coding: utf-8

#* library/duration/formatter.rb - Duration formatting support library.
module XfOOrth

  #Formatter support for the \Duration class.
  class Duration

    #Extend this class with attr_formatter support.
    extend FormatEngine::AttrFormatter

    ##
    #The specification of the formatter method of the \Duration class.
    #<br>Raw Formats (in seconds and fractions):
    #* %{w{.p}}f - Total seconds in floating point format.
    #* %{w}r - Total seconds in rational format
    #<br>Where:
    #* w is an optional field width parameter.
    #* p is an optional precision parameter.
    attr_formatter :strfmt,
    {
      "%f"  => lambda do
        format = fmt.width > 0 ? "%#{fmt.width}.#{fmt.prec}f" : "%f"
        cat format % src.period.to_f
      end,
      "%r"  => lambda {cat src.period.to_r.to_s.rjust(fmt.width) }
    }


  end

  format_action = lambda {|vm| vm.poke(self.strfmt(vm.peek)); }

  # [a_time a_string] format [a_string]
  Duration.create_shared_method('format', NosSpec, [], &format_action)

  # [a_time] f"string" [a_string]
  Duration.create_shared_method('f"', NosSpec, [], &format_action)

end