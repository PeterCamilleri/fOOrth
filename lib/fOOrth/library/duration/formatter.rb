# coding: utf-8

#* library/duration/formatter.rb - Duration formatting support library.
module XfOOrth

  #Formatter support for the \Duration class.
  class Duration

    #Extend this class with attr_formatter support.
    extend FormatEngine::AttrFormatter

    ##
    #The specification of the formatter method of the \Duration class.
    #<br>Year Formats:
    #* %{w}y - Whole years
    #* %{w{.p}}Y - Total (with fractional) years
    #<br>Raw Formats (in seconds and fractions):
    #* %{w{.p}}f - Total seconds in floating point format.
    #* %{w}r - Total seconds in rational format
    #<br>Where:
    #* w is an optional field width parameter.
    #* p is an optional precision parameter.
    attr_formatter :strfmt,
    {
      :before => lambda do
        arr = src.to_a
        tmp[:year]  = arr[0]
        tmp[:month] = arr[1]
        tmp[:day]   = arr[2]
        tmp[:hour]  = arr[3]
        tmp[:min]   = arr[4]
        tmp[:sec]   = arr[5]
      end,

      "%y"  => lambda {cat "%#{fmt.parm_str}d" % tmp[:year]      },
      "%-y" => lambda {cat "%-#{fmt.parm_str}d" % tmp[:year]     },

      "%?y" => lambda do
        cat "%#{fmt.parm_str}d" % tmp[:year] if tmp[:year] >= 1
      end,
      "%?-y"=> lambda do
        cat "%-#{fmt.parm_str}d" % tmp[:year] if tmp[:year] >= 1
      end,

      "%Y"  => lambda do
        cat "%#{fmt.parm_str}f" % src.as_years
      end,
      "%-Y" => lambda do
        cat "%-#{fmt.parm_str}f" % src.as_years
      end,

      "%?Y" => lambda do
        cat "%#{fmt.parm_str}f" % src.as_years if src.as_years > 0
      end,
      "%?-Y"=> lambda do
        cat "%-#{fmt.parm_str}f" % src.as_years if src.as_years > 0
      end,


      "%f"  => lambda {cat "%#{fmt.parm_str}f" % src.period.to_f },
      "%-f" => lambda {cat "%-#{fmt.parm_str}f" % src.period.to_f},
      "%r"  => lambda {cat src.period.to_r.to_s.rjust(fmt.width) },
      "%-r" => lambda {cat src.period.to_r.to_s.ljust(fmt.width) }
    }


  end

  format_action = lambda {|vm| vm.poke(self.strfmt(vm.peek)); }

  # [a_time a_string] format [a_string]
  Duration.create_shared_method('format', NosSpec, [], &format_action)

  # [a_time] f"string" [a_string]
  Duration.create_shared_method('f"', NosSpec, [], &format_action)

end
