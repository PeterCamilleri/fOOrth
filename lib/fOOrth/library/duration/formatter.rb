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
    #<br>Month Formats:
    #* %{w}o - Whole months in the year.
    #* %{w{.p}}O - Total (with fractional) months.
    #* %?{w}o - Whole months in the year, suppress if absent.
    #* %?{w{.p}}O - Total (with fractional) months, suppress if absent.
    #<br>Month Label Formats:
    #* %${w}o - Label for whole months in the year.
    #* %${w}O - Label for total (with fractional) months.
    #* %?${w}o - Label for whole months in the year, suppress if absent.
    #* %?${w}O - Label for total (with fractional) months, suppress if absent.
    #<br>Day Formats:
    #* %{w}d - Whole days in the month.
    #* %{w{.p}}D - Total (with fractional) days.
    #* %?{w}d - Whole days in the month, suppress if absent.
    #* %?{w{.p}}D - Total (with fractional) days, suppress if absent.
    #<br>Day Label Formats:
    #* %${w}d - Label for whole days in the month.
    #* %${w}D - Label for total (with fractional) days.
    #* %?${w}d - Label for whole days in the month, suppress if absent.
    #* %?${w}D - Label for total (with fractional) days, suppress if absent.
    #<br>Hour Formats:
    #* %{w}h - Whole hours in the day.
    #* %{w{.p}}H - Total (with fractional) hours.
    #* %?{w}h - Whole hours in the day, suppress if absent.
    #* %?{w{.p}}H - Total (with fractional) hours, suppress if absent.
    #<br>Hour Label Formats:
    #* %${w}h - Label for whole hours in the day.
    #* %${w}H - Label for total (with fractional) hours.
    #* %?${w}h - Label for whole hours in the day, suppress if absent.
    #* %?${w}H - Label for total (with fractional) hours, suppress if absent.
    #<br>Minute Formats:
    #* %{w}m - Whole minutes in the hour.
    #* %{w{.p}}M - Total (with fractional) minutes.
    #* %?{w}m - Whole minutes in the hour, suppress if absent.
    #* %?{w{.p}}M - Total (with fractional) minutes, suppress if absent.
    #<br>Minute Label Formats:
    #* %${w}m - Label for whole minutes in the hour.
    #* %${w}M - Label for total (with fractional) minutes.
    #* %?${w}m - Label for whole minutes in the hour, suppress if absent.
    #* %?${w}M - Label for total (with fractional) minutes, suppress if absent.
    #<br>Second Formats:
    #* %{w}s - Whole seconds in the minute.
    #* %{w{.p}}S - Total (with fractional) seconds.
    #* %?{w}s - Whole seconds in the minute, suppress if absent.
    #* %?{w{.p}}S - Total (with fractional) seconds, suppress if absent.
    #<br>Second Label Formats:
    #* %${w}s - Label for whole seconds in the minute.
    #* %${w}S - Label for total (with fractional) seconds.
    #* %?${w}s - Label for whole seconds in the minute, suppress if absent.
    #* %?${w}S - Label for total (with fractional) seconds, suppress if absent.
    #<br>Raw Formats (in seconds and fractions):
    #* %{w{.p}}f - Total seconds in floating point format.
    #* %{w}r - Total seconds in rational format.
    #<br>Where:
    #* w is an optional field width parameter.
    #* p is an optional precision parameter.
    attr_formatter :strfmt,
    {
      :before => lambda do
        tmp[:all]   = arr = src.to_a
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

      "%o"  => lambda {cat "%#{fmt.parm_str}d" % tmp[:month]},
      "%?o" => lambda {cat "%#{fmt.parm_str}d" % tmp[:month] if tmp[:month] >= 1},
      "%O"  => lambda {cat "%#{fmt.parm_str}f" % tmp[1]},
      "%?O" => lambda {cat "%#{fmt.parm_str}f" % tmp[1] if tmp[1] > 0},

      "%$o" => lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(1, tmp[:month])},
      "%?$o"=> lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(1, tmp[:month]) if tmp[:month] >= 1},
      "%$O" => lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(1, tmp[1])},
      "%?$O"=> lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(1, tmp[1]) if tmp[1] > 0},

      "%d"  => lambda {cat "%#{fmt.parm_str}d" % tmp[:day]},
      "%?d" => lambda {cat "%#{fmt.parm_str}d" % tmp[:day] if tmp[:day] >= 1},
      "%D"  => lambda {cat "%#{fmt.parm_str}f" % tmp[2]},
      "%?D" => lambda {cat "%#{fmt.parm_str}f" % tmp[2] if tmp[2] > 0},

      "%$d" => lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(2, tmp[:day])},
      "%?$d"=> lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(2, tmp[:day]) if tmp[:day] >= 1},
      "%$D" => lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(2, tmp[2])},
      "%?$D"=> lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(2, tmp[2]) if tmp[2] > 0},

      "%h"  => lambda {cat "%#{fmt.parm_str}d" % tmp[:hour]},
      "%?h" => lambda {cat "%#{fmt.parm_str}d" % tmp[:hour] if tmp[:hour] >= 1},
      "%H"  => lambda {cat "%#{fmt.parm_str}f" % tmp[3]},
      "%?H" => lambda {cat "%#{fmt.parm_str}f" % tmp[3] if tmp[3] > 0},

      "%$h" => lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(3, tmp[:hour])},
      "%?$h"=> lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(3, tmp[:hour]) if tmp[:hour] >= 1},
      "%$H" => lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(3, tmp[3])},
      "%?$H"=> lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(3, tmp[3]) if tmp[3] > 0},

      "%m"  => lambda {cat "%#{fmt.parm_str}d" % tmp[:min]},
      "%?m" => lambda {cat "%#{fmt.parm_str}d" % tmp[:min] if tmp[:min] >= 1},
      "%M"  => lambda {cat "%#{fmt.parm_str}f" % tmp[4]},
      "%?M" => lambda {cat "%#{fmt.parm_str}f" % tmp[4] if tmp[4] > 0},

      "%$m" => lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(4, tmp[:min])},
      "%?$m"=> lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(4, tmp[:min]) if tmp[:min] >= 1},
      "%$M" => lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(4, tmp[4])},
      "%?$M"=> lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(4, tmp[4]) if tmp[4] > 0},

      "%s"  => lambda {cat "%#{fmt.parm_str}d" % tmp[:sec]},
      "%?s" => lambda {cat "%#{fmt.parm_str}d" % tmp[:sec] if tmp[:sec] >= 1},
      "%S"  => lambda {cat "%#{fmt.parm_str}f" % tmp[5]},
      "%?S" => lambda {cat "%#{fmt.parm_str}f" % tmp[5] if tmp[5] > 0},

      "%$s" => lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(5, tmp[:sec])},
      "%?$s"=> lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(5, tmp[:sec]) if tmp[:sec] >= 1},
      "%$S" => lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(5, tmp[5])},
      "%?$S"=> lambda {cat "%#{fmt.parm_str}s" % Duration.pick_label(5, tmp[5]) if tmp[5] > 0},



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
