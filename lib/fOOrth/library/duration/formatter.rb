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
    #* %{?}{$}{w}y - Whole years.
    #* %{?}{$}{w{.p}}Y - Total (with fractional) years.
    #<br>Month Formats:
    #* %{?}{$}{w}o - Whole months in the year.
    #* %{?}{$}{w{.p}}O - Total (with fractional) months.
    #<br>Day Formats:
    #* %{?}{$}{w}d - Whole days in the month.
    #* %{?}{$}{w{.p}}D - Total (with fractional) days.
    #<br>Hour Formats:
    #* %{?}{$}{w}h - Whole hours in the day.
    #* %{?}{$}{w{.p}}H - Total (with fractional) hours.
    #<br>Minute Formats:
    #* %{?}{$}{w}m - Whole minutes in the hour.
    #* %{?}{$}{w{.p}}M - Total (with fractional) minutes.
    #<br>Second Formats:
    #* %{?}{$}{w}s - Whole seconds in the minute.
    #* %{?}{$}{w{.p}}S - Total (with fractional) seconds.
    #<br>Brief Summary Formats:
    #* %{?}{$}{w{.p}}B - Total (with fractional) of the largest, non-zero time unit.
    #<br>Raw Formats (in seconds and fractions):
    #* %{w{.p}}f - Total seconds in floating point format.
    #* %{w}r - Total seconds in rational format.
    #<br>Where:
    #* \? is an optional flag indicating that the data should be suppressed if absent.
    #* \$ is an optional flag indication to retrieve the corresponding text label.
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

      "%B"  => lambda {cat "%#{fmt.parm_str}f" % tmp[src.largest_interval]},
      "%?B" => lambda {cat "%#{fmt.parm_str}f" % tmp[src.largest_interval] if src.period > 0},

      "%$B" => lambda do
        index = src.largest_interval
        cat "%#{fmt.parm_str}s" % Duration.pick_label(index, tmp[index])
      end,
      "%?$B" => lambda do
        if src.period > 0
          index = src.largest_interval
          cat "%#{fmt.parm_str}s" % Duration.pick_label(index, tmp[index])
        end
      end,


      "%f"  => lambda {cat "%#{fmt.parm_str}f" % src.period.to_f},
      "%r"  => lambda {cat "%#{fmt.parm_str}s" % src.period.to_s}
    }


  end

  format_action = lambda do |vm|
    begin
      vm.poke(self.strfmt(vm.peek))
    rescue => err
      error "F40: Formating error: #{err.message}."
    end
  end

  # [a_time a_string] format [a_string]
  Duration.create_shared_method('format', NosSpec, [], &format_action)

  # [a_time] f"string" [a_string]
  Duration.create_shared_method('f"', NosSpec, [], &format_action)

end
