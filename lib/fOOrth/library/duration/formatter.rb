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
    #* %{w}y - Whole years.
    #* %{w{.p}}Y - Total (with fractional) years.
    #* %?{w}y - Whole years, suppress if absent.
    #* %?{w{.p}}Y - Total (with fractional) years, suppress if absent.
    #<br>Year Label Formats:
    #* %${w}y - Label for whole years.
    #* %${w}Y - Label for total (with fractional) years.
    #* %?${w}y - Label for whole years, suppress if absent.
    #* %?${w}Y - Label for total (with fractional) years, suppress if absent.
    #<br>Raw Formats (in seconds and fractions):
    #* %{w{.p}}f - Total seconds in floating point format.
    #* %{w}r - Total seconds in rational format.
    #<br>Where:
    #* w is an optional field width parameter.
    #* p is an optional precision parameter.
    attr_formatter :strfmt,
    {
      :before => lambda do
        arr = src.to_a
        tmp[:year]  = arr[0]; tmp[0] = src.as_years
        tmp[:month] = arr[1]; tmp[1] = src.as_months
        tmp[:day]   = arr[2]; tmp[2] = src.as_days
        tmp[:hour]  = arr[3]; tmp[3] = src.as_hours
        tmp[:min]   = arr[4]; tmp[4] = src.as_minutes
        tmp[:sec]   = arr[5]; tmp[5] = src.as_seconds
      end,

      "%y"  => lambda {cat "%#{fmt.parm_str}d" % tmp[:year]},
      "%?y" => lambda {cat "%#{fmt.parm_str}d" % tmp[:year] if tmp[:year] >= 1},
      "%Y"  => lambda {cat "%#{fmt.parm_str}f" % tmp[0]},
      "%?Y" => lambda {cat "%#{fmt.parm_str}f" % tmp[0] if tmp[0] > 0},

      "%$y" => lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(0, tmp[:year])},
      "%?$y"=> lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(0, tmp[:year]) if tmp[:year] >= 1},

      "%$Y" => lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(0, tmp[0])},
      "%?$Y"=> lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(0, tmp[0]) if tmp[0] > 0},


      "%f"  => lambda {cat "%#{fmt.parm_str}f" % src.period.to_f},
      "%r"  => lambda {cat "%#{fmt.parm_str}s" % src.period.to_s}
    }


  end

  format_action = lambda {|vm| vm.poke(self.strfmt(vm.peek)); }

  # [a_time a_string] format [a_string]
  Duration.create_shared_method('format', NosSpec, [], &format_action)

  # [a_time] f"string" [a_string]
  Duration.create_shared_method('f"', NosSpec, [], &format_action)

end
