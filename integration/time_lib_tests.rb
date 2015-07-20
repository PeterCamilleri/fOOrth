# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the fOOrth time and duration libraries.
class TimeLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_that_the_time_classes_exists
    foorth_equal('Time', [Time])
    foorth_equal('Duration', [XfOOrth::Duration])
  end

  def test_that_new_not_allowed
    foorth_raises('Time .new')
    foorth_raises('Duration .new')
  end

  def test_some_time_duration_values
    foorth_equal('now .class', [Time])
    foorth_equal('local_offset', [Time.now.utc_offset])

    foorth_equal('Duration .intervals',
                 [[31_556_952, 2_629_746, 86_400, 3_600, 60, 1]])

    foorth_equal('Duration .labels',
                 [["years", "months", "days", "hours", "minutes", "seconds"]])

    foorth_equal('a_year',   [31_556_952])
    foorth_equal('a_month',  [ 2_629_746])
    foorth_equal('a_day',    [    86_400])
    foorth_equal('an_hour',  [     3_600])
    foorth_equal('a_minute', [        60])
    foorth_equal('a_second', [         1])

    foorth_equal('a_year   .class', [XfOOrth::Duration])
    foorth_equal('a_month  .class', [XfOOrth::Duration])
    foorth_equal('a_day    .class', [XfOOrth::Duration])
    foorth_equal('an_hour  .class', [XfOOrth::Duration])
    foorth_equal('a_minute .class', [XfOOrth::Duration])
    foorth_equal('a_second .class', [XfOOrth::Duration])

    foorth_equal('a_year         .years     ', [1])
    foorth_equal('a_year   3/2 * .years     ', [1])
    foorth_equal('a_year     2 * .years     ', [2])

    foorth_equal('a_year         .months    ', [0])
    foorth_equal('a_year   3/2 * .months    ', [6])
    foorth_equal('a_year     2 * .months    ', [0])
    foorth_equal('a_month        .months    ', [1])
    foorth_equal('a_month  3/2 * .months    ', [1])
    foorth_equal('a_month    2 * .months    ', [2])

    foorth_equal('a_year         .days      ', [0])
    foorth_equal('a_year   3/2 * .days      ', [0])
    foorth_equal('a_year     2 * .days      ', [0])
    foorth_equal('a_month        .days      ', [0])
    foorth_equal('a_month  3/2 * .days      ', [15])
    foorth_equal('a_month    2 * .days      ', [0])
    foorth_equal('a_day          .days      ', [1])
    foorth_equal('a_day    3/2 * .days      ', [1])
    foorth_equal('a_day      2 * .days      ', [2])

    foorth_equal('a_year         .hours     ', [0])
    foorth_equal('a_year   3/2 * .hours     ', [0])
    foorth_equal('a_year     2 * .hours     ', [0])
    foorth_equal('a_month        .hours     ', [0])
    foorth_equal('a_month  3/2 * .hours     ', [5])
    foorth_equal('a_month    2 * .hours     ', [0])
    foorth_equal('a_day          .hours     ', [0])
    foorth_equal('a_day    3/2 * .hours     ', [12])
    foorth_equal('a_day      2 * .hours     ', [0])
    foorth_equal('an_hour        .hours     ', [1])
    foorth_equal('an_hour  3/2 * .hours     ', [1])
    foorth_equal('an_hour    2 * .hours     ', [2])

    foorth_equal('a_year         .minutes   ', [0])
    foorth_equal('a_year   3/2 * .minutes   ', [0])
    foorth_equal('a_year     2 * .minutes   ', [0])
    foorth_equal('a_month        .minutes   ', [0])
    foorth_equal('a_month  3/2 * .minutes   ', [14])
    foorth_equal('a_month    2 * .minutes   ', [0])
    foorth_equal('a_day          .minutes   ', [0])
    foorth_equal('a_day    3/2 * .minutes   ', [0])
    foorth_equal('a_day      2 * .minutes   ', [0])
    foorth_equal('an_hour        .minutes   ', [0])
    foorth_equal('an_hour  3/2 * .minutes   ', [30])
    foorth_equal('an_hour    2 * .minutes   ', [0])
    foorth_equal('a_minute       .minutes   ', [1])
    foorth_equal('a_minute 3/2 * .minutes   ', [1])
    foorth_equal('a_minute   2 * .minutes   ', [2])

    foorth_equal('a_year         .seconds   ', [0])
    foorth_equal('a_year   3/2 * .seconds   ', [0])
    foorth_equal('a_year     2 * .seconds   ', [0])
    foorth_equal('a_month        .seconds   ', [0])
    foorth_equal('a_month  3/2 * .seconds   ', [33])
    foorth_equal('a_month    2 * .seconds   ', [0])
    foorth_equal('a_day          .seconds   ', [0])
    foorth_equal('a_day    3/2 * .seconds   ', [0])
    foorth_equal('a_day      2 * .seconds   ', [0])
    foorth_equal('an_hour        .seconds   ', [0])
    foorth_equal('an_hour  3/2 * .seconds   ', [0])
    foorth_equal('an_hour    2 * .seconds   ', [0])
    foorth_equal('a_minute       .seconds   ', [0])
    foorth_equal('a_minute 3/2 * .seconds   ', [30])
    foorth_equal('a_minute   2 * .seconds   ', [0])
    foorth_equal('a_second       .seconds   ', [1])
    foorth_equal('a_second 3/2 * .seconds   ', [1.5])
    foorth_equal('a_second   2 * .seconds   ', [2])

    foorth_equal('a_year         .as_years  ', [1])
    foorth_equal('a_year   3/2 * .as_years  ', [1.5])
    foorth_equal('a_year     2 * .as_years  ', [2])

    foorth_equal('a_year         .as_months ', [12])
    foorth_equal('a_year   3/2 * .as_months ', [18])
    foorth_equal('a_year     2 * .as_months ', [24])
    foorth_equal('a_month        .as_months ', [1])
    foorth_equal('a_month  3/2 * .as_months ', [1.5])
    foorth_equal('a_month    2 * .as_months ', [2])

    foorth_equal('a_year         .as_days   ', [365.2425])
    foorth_equal('a_year   3/2 * .as_days   ', [1.5*365.2425])
    foorth_equal('a_year     2 * .as_days   ', [2*365.2425])
    foorth_equal('a_month        .as_days   ', [365.2425/12])
    foorth_equal('a_month  3/2 * .as_days   ', [1.5*365.2425/12])
    foorth_equal('a_month    2 * .as_days   ', [365.2425/6])
    foorth_equal('a_day          .as_days   ', [1])
    foorth_equal('a_day    3/2 * .as_days   ', [1.5])
    foorth_equal('a_day      2 * .as_days   ', [2])

    foorth_equal('a_year         .as_hours  ', [8765.82])
    foorth_equal('a_year   3/2 * .as_hours  ', [13148.73])
    foorth_equal('a_year     2 * .as_hours  ', [17531.64])
    foorth_equal('a_month        .as_hours  ', [730.485])
    foorth_equal('a_month  3/2 * .as_hours  ', [1095.7275])
    foorth_equal('a_month    2 * .as_hours  ', [1460.97])
    foorth_equal('a_day          .as_hours  ', [24])
    foorth_equal('a_day    3/2 * .as_hours  ', [36])
    foorth_equal('a_day      2 * .as_hours  ', [48])
    foorth_equal('an_hour        .as_hours  ', [1])
    foorth_equal('an_hour  3/2 * .as_hours  ', [1.5])
    foorth_equal('an_hour    2 * .as_hours  ', [2])

    foorth_equal('a_year         .as_minutes', [525949.2])
    foorth_equal('a_year   3/2 * .as_minutes', [788923.8])
    foorth_equal('a_year     2 * .as_minutes', [1051898.4])
    foorth_equal('a_month        .as_minutes', [43829.1])
    foorth_equal('a_month  3/2 * .as_minutes', [65743.65])
    foorth_equal('a_month    2 * .as_minutes', [87658.2])
    foorth_equal('a_day          .as_minutes', [1440])
    foorth_equal('a_day    3/2 * .as_minutes', [2160])
    foorth_equal('a_day      2 * .as_minutes', [2880])
    foorth_equal('an_hour        .as_minutes', [60])
    foorth_equal('an_hour  3/2 * .as_minutes', [90])
    foorth_equal('an_hour    2 * .as_minutes', [120])
    foorth_equal('a_minute       .as_minutes', [1])
    foorth_equal('a_minute 3/2 * .as_minutes', [1.5])
    foorth_equal('a_minute   2 * .as_minutes', [2])

    foorth_equal('a_year         .as_seconds', [31556952])
    foorth_equal('a_year   3/2 * .as_seconds', [47335428])
    foorth_equal('a_year     2 * .as_seconds', [63113904])
    foorth_equal('a_month        .as_seconds', [2629746])
    foorth_equal('a_month  3/2 * .as_seconds', [3944619])
    foorth_equal('a_month    2 * .as_seconds', [5259492])
    foorth_equal('a_day          .as_seconds', [86400])
    foorth_equal('a_day    3/2 * .as_seconds', [129600])
    foorth_equal('a_day      2 * .as_seconds', [172800])
    foorth_equal('an_hour        .as_seconds', [3600])
    foorth_equal('an_hour  3/2 * .as_seconds', [5400])
    foorth_equal('an_hour  2   * .as_seconds', [7200])
    foorth_equal('a_minute       .as_seconds', [60])
    foorth_equal('a_minute 3/2 * .as_seconds', [90])
    foorth_equal('a_minute   2 * .as_seconds', [120])
    foorth_equal('a_second       .as_seconds', [1])
    foorth_equal('a_second 3/2 * .as_seconds', [1.5])
    foorth_equal('a_second   2 * .as_seconds', [2])

  end

  def test_converting_to_time
    foorth_equal('0 .to_t',        [Time.at(0)])
    foorth_equal('0 .to_t!',       [Time.at(0)])
    foorth_equal('infinity .to_t', [nil])
    foorth_raises('infinity .to_t!')

    foorth_raises('1+1i .to_t')
    foorth_raises('1+1i .to_t!')

    foorth_equal('"Oct 26 1985 1:22" .to_t',  [Time.parse("Oct 26 1985 1:22")])
    foorth_equal('"Oct 26 1985 1:22" .to_t!', [Time.parse("Oct 26 1985 1:22")])
    foorth_equal('"apple" .to_t',  [nil])
    foorth_raises('"apple" .to_t!')

    foorth_equal('0 .to_t .to_t',  [Time.at(0)])
    foorth_equal('0 .to_t .to_t!', [Time.at(0)])
  end

  def test_converting_to_duration
    foorth_equal('0 .to_duration',        [XfOOrth::Duration.new("0/1".to_r)])
    foorth_equal('"apple"  .to_duration', [nil])
    foorth_equal('infinity .to_duration', [nil])
    foorth_equal('1+2i .to_duration',     [nil])

    foorth_equal('0 .to_duration!',       [XfOOrth::Duration.new("0/1".to_r)])
    foorth_raises('"apple" .to_duration!')
    foorth_raises('infinity .to_duration!')
    foorth_raises('1+2i .to_duration!')

    foorth_equal('[           0 ] .to_duration', [XfOOrth::Duration.new(       0.to_r)])
    foorth_equal('[           1 ] .to_duration', [XfOOrth::Duration.new(       1.to_r)])
    foorth_equal('[         1 1 ] .to_duration', [XfOOrth::Duration.new(      61.to_r)])
    foorth_equal('[       1 1 1 ] .to_duration', [XfOOrth::Duration.new(    3661.to_r)])
    foorth_equal('[     1 1 1 1 ] .to_duration', [XfOOrth::Duration.new(   90061.to_r)])
    foorth_equal('[   1 1 1 1 1 ] .to_duration', [XfOOrth::Duration.new( 2719807.to_r)])
    foorth_equal('[ 1 1 1 1 1 1 ] .to_duration', [XfOOrth::Duration.new(34276759.to_r)])

    foorth_equal('[ 1 1 1 1 1 1 1 ] .to_duration', [nil])
    foorth_equal('[ 1 "apple" 1 1 ] .to_duration', [nil])

    foorth_equal('[           0 ] .to_duration!', [XfOOrth::Duration.new(       0.to_r)])
    foorth_equal('[           1 ] .to_duration!', [XfOOrth::Duration.new(       1.to_r)])
    foorth_equal('[         1 1 ] .to_duration!', [XfOOrth::Duration.new(      61.to_r)])
    foorth_equal('[       1 1 1 ] .to_duration!', [XfOOrth::Duration.new(    3661.to_r)])
    foorth_equal('[     1 1 1 1 ] .to_duration!', [XfOOrth::Duration.new(   90061.to_r)])
    foorth_equal('[   1 1 1 1 1 ] .to_duration!', [XfOOrth::Duration.new( 2719807.to_r)])
    foorth_equal('[ 1 1 1 1 1 1 ] .to_duration!', [XfOOrth::Duration.new(34276759.to_r)])

    foorth_raises('[ 1 1 1 1 1 1 1 ] .to_duration!')
    foorth_raises('[ 1 "apple" 1 1 ] .to_duration!')

    foorth_equal('[       2.5 ] .to_duration', [XfOOrth::Duration.new(  (2.5).to_r)])
    foorth_equal('[     2.5 0 ] .to_duration', [XfOOrth::Duration.new(    150.to_r)])
    foorth_equal('[   2.5 0 0 ] .to_duration', [XfOOrth::Duration.new(   9000.to_r)])
    foorth_equal('[ 2.5 0 0 0 ] .to_duration', [XfOOrth::Duration.new( 216000.to_r)])

  end

  def test_converting_from_a_duration
    foorth_equal('5 .to_duration .to_r', ["5/1".to_r])
    foorth_equal('5 .to_duration .to_f', [5.0])

    foorth_equal('0.4          .to_duration .to_a', [[0, 0, 0, 0, 0, 0.4]])
    foorth_equal('5.4          .to_duration .to_a', [[0, 0, 0, 0, 0, 5.4]])
    foorth_equal('5            .to_duration .to_a', [[0, 0, 0, 0, 0, 5  ]])
    foorth_equal('60           .to_duration .to_a', [[0, 0, 0, 0, 1, 0  ]])
    foorth_equal('31556952     .to_duration .to_a', [[1, 0, 0, 0, 0, 0  ]])
    foorth_equal('315569523/10 .to_duration .to_a', [[1, 0, 0, 0, 0, 0.3]])

  end

  def test_duration_comparisons
    foorth_equal("0 .to_duration 0 .to_duration =", [true])
    foorth_equal("1 .to_duration 0 .to_duration =", [false])
    foorth_equal("0 .to_duration 1 .to_duration =", [false])

    foorth_equal("0 .to_duration 0 =", [true])
    foorth_equal("1 .to_duration 0 =", [false])
    foorth_equal("0 .to_duration 1 =", [false])

    foorth_equal("0 0 .to_duration =", [true])
    foorth_equal("1 0 .to_duration =", [false])
    foorth_equal("0 1 .to_duration =", [false])

    foorth_equal('0 .to_duration "to" =', [false])
    foorth_equal("0 .to_duration 1+2i =", [false])


    foorth_equal("0 .to_duration! 0 .to_duration <>", [false])
    foorth_equal("1 .to_duration  0 .to_duration <>", [true])
    foorth_equal("0 .to_duration  1 .to_duration <>", [true])

    foorth_equal("0 .to_duration 0 <>", [false])
    foorth_equal("1 .to_duration 0 <>", [true])
    foorth_equal("0 .to_duration 1 <>", [true])

    foorth_equal("0 0 .to_duration <>", [false])
    foorth_equal("1 0 .to_duration <>", [true])
    foorth_equal("0 1 .to_duration <>", [true])

    foorth_equal('0 .to_duration "to" <>', [true])
    foorth_equal("0 .to_duration 1+2i <>", [true])


    foorth_equal("0 .to_duration 0 .to_duration >", [false])
    foorth_equal("1 .to_duration 0 .to_duration >", [true])
    foorth_equal("0 .to_duration 1 .to_duration >", [false])

    foorth_equal("0 .to_duration 0 >", [false])
    foorth_equal("1 .to_duration 0 >", [true])
    foorth_equal("0 .to_duration 1 >", [false])

    foorth_equal("0 0 .to_duration >", [false])
    foorth_equal("1 0 .to_duration >", [true])
    foorth_equal("0 1 .to_duration >", [false])

    foorth_raises("0 .to_duration 1+2i >")
    foorth_raises('0 .to_duration "to" >')


    foorth_equal("0 .to_duration 0 .to_duration >=", [true])
    foorth_equal("1 .to_duration 0 .to_duration >=", [true])
    foorth_equal("0 .to_duration 1 .to_duration >=", [false])

    foorth_equal("0 .to_duration 0 >=", [true])
    foorth_equal("1 .to_duration 0 >=", [true])
    foorth_equal("0 .to_duration 1 >=", [false])

    foorth_equal("0 0 .to_duration >=", [true])
    foorth_equal("1 0 .to_duration >=", [true])
    foorth_equal("0 1 .to_duration >=", [false])

    foorth_raises("0 .to_duration 1+2i >=")
    foorth_raises('0 .to_duration "to" >=')


    foorth_equal("0 .to_duration 0 .to_duration <", [false])
    foorth_equal("1 .to_duration 0 .to_duration <", [false])
    foorth_equal("0 .to_duration 1 .to_duration <", [true])

    foorth_equal("0 .to_duration 0 <", [false])
    foorth_equal("1 .to_duration 0 <", [false])
    foorth_equal("0 .to_duration 1 <", [true])

    foorth_equal("0 0 .to_duration <", [false])
    foorth_equal("1 0 .to_duration <", [false])
    foorth_equal("0 1 .to_duration <", [true])

    foorth_raises("0 .to_duration 1+2i <")
    foorth_raises('0 .to_duration "to" <')


    foorth_equal("0 .to_duration 0 .to_duration <=", [true])
    foorth_equal("1 .to_duration 0 .to_duration <=", [false])
    foorth_equal("0 .to_duration 1 .to_duration <=", [true])

    foorth_equal("0 .to_duration 0 <=", [true])
    foorth_equal("1 .to_duration 0 <=", [false])
    foorth_equal("0 .to_duration 1 <=", [true])

    foorth_equal("0 0 .to_duration <=", [true])
    foorth_equal("1 0 .to_duration <=", [false])
    foorth_equal("0 1 .to_duration <=", [true])

    foorth_raises("0 .to_duration 1+2i <=")
    foorth_raises('0 .to_duration "to" <=')


    foorth_equal("0 .to_duration 0 .to_duration <=>", [0])
    foorth_equal("1 .to_duration 0 .to_duration <=>", [1])
    foorth_equal("0 .to_duration 1 .to_duration <=>", [-1])

    foorth_equal("0 .to_duration 0 <=>", [0])
    foorth_equal("1 .to_duration 0 <=>", [1])
    foorth_equal("0 .to_duration 1 <=>", [-1])

    foorth_equal("0 0 .to_duration <=>", [0])
    foorth_equal("1 0 .to_duration <=>", [1])
    foorth_equal("0 1 .to_duration <=>", [-1])

    foorth_raises("0 .to_duration 1+2i <=>")
    foorth_raises('0 .to_duration "to" <=>')
  end

  def test_some_duration_formatting
    foorth_equal('4/3    .to_duration f"%r seconds"    ', ["4/3 seconds"])
    foorth_equal('4/3    .to_duration f"%8r seconds"   ', ["     4/3 seconds"])
    foorth_equal('4/3    .to_duration f"%-8r seconds"  ', ["4/3      seconds"])
    foorth_equal('44/3   .to_duration f"%4r seconds"   ', ["44/3 seconds"])

    foorth_equal('4/3    .to_duration f"%f seconds"    ', ["1.333333 seconds"])
    foorth_equal('4/3    .to_duration f"%8.2f seconds" ', ["    1.33 seconds"])
    foorth_equal('4/3    .to_duration f"%-8.2f seconds"', ["1.33     seconds"])
    foorth_equal('100.25 .to_duration f"%4.2f seconds" ', ["100.25 seconds"])

    foorth_equal('0 .to_duration f"%y%$y"       ', ["0 years"])
    foorth_equal('a_year         f"%y%$y"       ', ["1 year"])
    foorth_equal('a_year  5/2 *  f"%3y%$y"      ', ["  2 years"])
    foorth_equal('a_year  5/2 *  f"%-3y%$y"     ', ["2   years"])

    foorth_equal('0 .to_duration f"%?3y%?$y"    ', [""])
    foorth_equal('a_year         f"%?3y%?$y"    ', ["  1 year"])
    foorth_equal('a_year  5/2 *  f"%?3y%?$y"    ', ["  2 years"])
    foorth_equal('a_year  5/2 *  f"%?-3y%?$y"   ', ["2   years"])

    foorth_equal('0 .to_duration f"%4.1Y%$Y"    ', [" 0.0 years"])
    foorth_equal('a_year         f"%4.1Y%$Y"    ', [" 1.0 year"])
    foorth_equal('a_year  5/2 *  f"%4.1Y%$Y"    ', [" 2.5 years"])
    foorth_equal('a_year  5/2 *  f"%-4.1Y%$Y"   ', ["2.5  years"])

    foorth_equal('0 .to_duration f"%?4.1Y%?$Y"  ', [""])
    foorth_equal('a_year         f"%?4.1Y%?$Y"  ', [" 1.0 year"])
    foorth_equal('a_year  5/2 *  f"%?4.1Y%?$Y"  ', [" 2.5 years"])
    foorth_equal('a_year  5/2 *  f"%?-4.1Y%?$Y" ', ["2.5  years"])

    foorth_equal('0 .to_duration f"%o%$o"       ', ["0 months"])
    foorth_equal('a_year         f"%o%$o"       ', ["0 months"])
    foorth_equal('a_year   5/2 * f"%3o%$o"      ', ["  6 months"])
    foorth_equal('a_year   5/2 * f"%-3o%$o"     ', ["6   months"])
    foorth_equal('a_month        f"%-3o%$o"     ', ["1   month"])
    foorth_equal('a_month  5/2 * f"%-3o%$o"     ', ["2   months"])

    foorth_equal('0 .to_duration f"%?3o%?$o"    ', [""])
    foorth_equal('a_year         f"%?3o%?$o"    ', [""])
    foorth_equal('a_year   5/2 * f"%?3o%?$o"    ', ["  6 months"])
    foorth_equal('a_year   5/2 * f"%?-3o%?$o"   ', ["6   months"])
    foorth_equal('a_month        f"%?-3o%?$o"   ', ["1   month"])
    foorth_equal('a_month  5/2 * f"%?-3o%?$o"   ', ["2   months"])

    foorth_equal('0 .to_duration f"%4.1O%$O"    ', [" 0.0 months"])
    foorth_equal('a_year         f"%4.1O%$O"    ', ["12.0 months"])
    foorth_equal('a_year   5/2 * f"%4.1O%$O"    ', ["30.0 months"])
    foorth_equal('a_year   5/2 * f"%-4.1O%$O"   ', ["30.0 months"])
    foorth_equal('a_month        f"%-4.1O%$O"   ', ["1.0  month"])
    foorth_equal('a_month  5/2 * f"%-4.1O%$O"   ', ["2.5  months"])

    foorth_equal('0 .to_duration f"%?4.1O%?$O"  ', [""])
    foorth_equal('a_year         f"%?4.1O%?$O"  ', ["12.0 months"])
    foorth_equal('a_year   5/2 * f"%?4.1O%?$O"  ', ["30.0 months"])
    foorth_equal('a_year   5/2 * f"%?-4.1O%?$O" ', ["30.0 months"])
    foorth_equal('a_month        f"%?-4.1O%?$O" ', ["1.0  month"])
    foorth_equal('a_month  5/2 * f"%?-4.1O%?$O" ', ["2.5  months"])

    foorth_equal('0 .to_duration f"%d%$d"       ', ["0 days"])
    foorth_equal('a_year         f"%d%$d"       ', ["0 days"])
    foorth_equal('a_month        f"%-3d%$d"     ', ["0   days"])
    foorth_equal('a_month  5/2 * f"%-3d%$d"     ', ["15  days"])
    foorth_equal('a_day          f"%-3d%$d"     ', ["1   day"])
    foorth_equal('a_day      2 * f"%-3d%$d"     ', ["2   days"])

    foorth_equal('0 .to_duration f"%?d%?$d"     ', [""])
    foorth_equal('a_year         f"%?d%?$d"     ', [""])
    foorth_equal('a_month        f"%?-3d%?$d"   ', [""])
    foorth_equal('a_month  5/2 * f"%?-3d%?$d"   ', ["15  days"])
    foorth_equal('a_day          f"%?-3d%?$d"   ', ["1   day"])
    foorth_equal('a_day      2 * f"%?-3d%?$d"   ', ["2   days"])

    foorth_equal('0 .to_duration f"%4.1D%$D"    ', [" 0.0 days"])
    foorth_equal('a_year         f"%4.1D%$D"    ', ["365.2 days"])
    foorth_equal('a_month        f"%-4.1D%$D"   ', ["30.4 days"])
    foorth_equal('a_month  5/2 * f"%-4.1D%$D"   ', ["76.1 days"])
    foorth_equal('a_day          f"%-4.1D%$D"   ', ["1.0  day"])
    foorth_equal('a_day    5/2 * f"%-4.1D%$D"   ', ["2.5  days"])

    foorth_equal('0 .to_duration f"%?4.1D%?$D"  ', [""])
    foorth_equal('a_year         f"%?4.1D%?$D"  ', ["365.2 days"])
    foorth_equal('a_month        f"%?-4.1D%?$D" ', ["30.4 days"])
    foorth_equal('a_month  5/2 * f"%?-4.1D%?$D" ', ["76.1 days"])
    foorth_equal('a_day          f"%?-4.1D%?$D" ', ["1.0  day"])
    foorth_equal('a_day    5/2 * f"%?-4.1D%?$D" ', ["2.5  days"])

    foorth_equal('0 .to_duration f"%h%$h"       ', ["0 hours"])
    foorth_equal('a_day          f"%-3h%$h"     ', ["0   hours"])
    foorth_equal('a_day    5/2 * f"%-3h%$h"     ', ["12  hours"])
    foorth_equal('an_hour        f"%-3h%$h"     ', ["1   hour"])
    foorth_equal('an_hour  5/2 * f"%-3h%$h"     ', ["2   hours"])

    foorth_equal('0 .to_duration f"%?h%?$h"     ', [""])
    foorth_equal('a_day          f"%?-3h%?$h"   ', [""])
    foorth_equal('a_day    5/2 * f"%?-3h%?$h"   ', ["12  hours"])
    foorth_equal('an_hour        f"%?-3h%?$h"   ', ["1   hour"])
    foorth_equal('an_hour  5/2 * f"%?-3h%?$h"   ', ["2   hours"])

    foorth_equal('0 .to_duration f"%4.1H%$H"    ', [" 0.0 hours"])
    foorth_equal('a_day          f"%-4.1H%$H"   ', ["24.0 hours"])
    foorth_equal('a_day    5/2 * f"%-4.1H%$H"   ', ["60.0 hours"])
    foorth_equal('an_hour        f"%-4.1H%$H"   ', ["1.0  hour"])
    foorth_equal('an_hour  5/2 * f"%-4.1H%$H"   ', ["2.5  hours"])

    foorth_equal('0 .to_duration f"%?4.1H%?$H"  ', [""])
    foorth_equal('a_day          f"%?-4.1H%?$H" ', ["24.0 hours"])
    foorth_equal('a_day    5/2 * f"%?-4.1H%?$H" ', ["60.0 hours"])
    foorth_equal('an_hour        f"%?-4.1H%?$H" ', ["1.0  hour"])
    foorth_equal('an_hour  5/2 * f"%?-4.1H%?$H" ', ["2.5  hours"])

    foorth_equal('0 .to_duration f"%m%$m"       ', ["0 minutes"])
    foorth_equal('an_hour        f"%-3m%$m"     ', ["0   minutes"])
    foorth_equal('an_hour  5/2 * f"%-3m%$m"     ', ["30  minutes"])
    foorth_equal('a_minute       f"%-3m%$m"     ', ["1   minute"])
    foorth_equal('a_minute 5/2 * f"%-3m%$m"     ', ["2   minutes"])

    foorth_equal('0 .to_duration f"%?m%?$m"     ', [""])
    foorth_equal('an_hour        f"%?-3m%?$m"   ', [""])
    foorth_equal('an_hour  5/2 * f"%?-3m%?$m"   ', ["30  minutes"])
    foorth_equal('a_minute       f"%?-3m%?$m"   ', ["1   minute"])
    foorth_equal('a_minute 5/2 * f"%?-3m%?$m"   ', ["2   minutes"])

    foorth_equal('0 .to_duration f"%4.1M%$M"    ', [" 0.0 minutes"])
    foorth_equal('an_hour        f"%-4.1M%$M"   ', ["60.0 minutes"])
    foorth_equal('an_hour  5/2 * f"%-4.1M%$M"   ', ["150.0 minutes"])
    foorth_equal('a_minute       f"%-4.1M%$M"   ', ["1.0  minute"])
    foorth_equal('a_minute 5/2 * f"%-4.1M%$M"   ', ["2.5  minutes"])

    foorth_equal('0 .to_duration f"%?4.1M%?$M"  ', [""])
    foorth_equal('an_hour        f"%?-4.1M%?$M" ', ["60.0 minutes"])
    foorth_equal('an_hour  5/2 * f"%?-4.1M%?$M" ', ["150.0 minutes"])
    foorth_equal('a_minute       f"%?-4.1M%?$M" ', ["1.0  minute"])
    foorth_equal('a_minute 5/2 * f"%?-4.1M%?$M" ', ["2.5  minutes"])

    foorth_equal('0 .to_duration f"%s%$s"       ', ["0 seconds"])
    foorth_equal('a_minute       f"%-3s%$s"     ', ["0   seconds"])
    foorth_equal('a_minute 5/2 * f"%-3s%$s"     ', ["30  seconds"])
    foorth_equal('a_second       f"%-3s%$s"     ', ["1   second"])
    foorth_equal('a_second 5/2 * f"%-3s%$s"     ', ["2   seconds"])

    foorth_equal('0 .to_duration f"%?s%?$s"     ', [""])
    foorth_equal('a_minute       f"%?-3s%?$s"   ', [""])
    foorth_equal('a_minute 5/2 * f"%?-3s%?$s"   ', ["30  seconds"])
    foorth_equal('a_second       f"%?-3s%?$s"   ', ["1   second"])
    foorth_equal('a_second 5/2 * f"%?-3s%?$s"   ', ["2   seconds"])

    foorth_equal('0 .to_duration f"%4.1S%$S"    ', [" 0.0 seconds"])
    foorth_equal('a_minute       f"%-4.1S%$S"   ', ["60.0 seconds"])
    foorth_equal('a_minute 5/2 * f"%-4.1S%$S"   ', ["150.0 seconds"])
    foorth_equal('a_second       f"%-4.1S%$S"   ', ["1.0  second"])
    foorth_equal('a_second 5/2 * f"%-4.1S%$S"   ', ["2.5  seconds"])

    foorth_equal('0 .to_duration f"%?4.1S%?$S"  ', [""])
    foorth_equal('a_minute       f"%?-4.1S%?$S" ', ["60.0 seconds"])
    foorth_equal('a_minute 5/2 * f"%?-4.1S%?$S" ', ["150.0 seconds"])
    foorth_equal('a_second       f"%?-4.1S%?$S" ', ["1.0  second"])
    foorth_equal('a_second 5/2 * f"%?-4.1S%?$S" ', ["2.5  seconds"])




  end

  def test_time_comparisons
    foorth_equal('1434322206 .to_t  1434322206 .to_t >  ', [false])
    foorth_equal('1434322200 .to_t  1434322206 .to_t >  ', [false])
    foorth_equal('1434322206 .to_t  1434322200 .to_t >  ', [true])

    foorth_equal('1434322206 .to_t  1434322206 .to_t >= ', [true])
    foorth_equal('1434322200 .to_t  1434322206 .to_t >= ', [false])
    foorth_equal('1434322206 .to_t  1434322200 .to_t >= ', [true])

    foorth_equal('1434322206 .to_t  1434322206 .to_t <  ', [false])
    foorth_equal('1434322200 .to_t  1434322206 .to_t <  ', [true])
    foorth_equal('1434322206 .to_t  1434322200 .to_t <  ', [false])

    foorth_equal('1434322206 .to_t  1434322206 .to_t <= ', [true])
    foorth_equal('1434322200 .to_t  1434322206 .to_t <= ', [true])
    foorth_equal('1434322206 .to_t  1434322200 .to_t <= ', [false])

    foorth_equal('1434322206 .to_t  1434322206 .to_t =  ', [true])
    foorth_equal('1434322200 .to_t  1434322206 .to_t =  ', [false])
    foorth_equal('1434322206 .to_t  1434322200 .to_t =  ', [false])

    foorth_equal('1434322206 .to_t  1434322206 .to_t <> ', [false])
    foorth_equal('1434322200 .to_t  1434322206 .to_t <> ', [true])
    foorth_equal('1434322206 .to_t  1434322200 .to_t <> ', [true])

    foorth_equal('1434322206 .to_t  1434322200 .to_t <=>', [1])
    foorth_equal('1434322206 .to_t  1434322206 .to_t <=>', [0])
    foorth_equal('1434322200 .to_t  1434322206 .to_t <=>', [-1])
  end

  def test_some_time_math
    foorth_equal('1434322206 .to_t 100 + ', [Time.at(1434322206+100)])
    foorth_raises('1434322206 .to_t now  + ')
    foorth_raises('1434322206 .to_t "apple"  + ')

    foorth_equal('1434322206 .to_t 100 - ', [Time.at(1434322206-100)])
    foorth_equal('1434322206 .to_t 1434322206 .to_t -       ', [XfOOrth::Duration.new(0.to_r)])
    foorth_equal('1434322206 .to_t 1434322206 .to_t - .class', [XfOOrth::Duration])

    foorth_raises('1434322206 .to_t "apple"  - ')
  end

  def test_some_duration_math
    foorth_equal('100              50 .to_duration +        ', [150] )
    foorth_equal('100 .to_duration 50              +        ', [150] )
    foorth_equal('100 .to_duration 50 .to_duration +        ', [150] )

    foorth_equal('100              50 .to_duration + .class ', [Fixnum] )
    foorth_equal('100 .to_duration 50              + .class ', [XfOOrth::Duration] )
    foorth_equal('100 .to_duration 50 .to_duration + .class ', [XfOOrth::Duration] )

    foorth_equal('100 .to_duration dup 50              + distinct?', [true] )
    foorth_equal('100 .to_duration dup 50 .to_duration + distinct?', [true] )


    foorth_equal('100              50 .to_duration -        ', [50] )
    foorth_equal('100 .to_duration 50              -        ', [50] )
    foorth_equal('100 .to_duration 50 .to_duration -        ', [50] )

    foorth_equal('100              50 .to_duration - .class ', [Fixnum] )
    foorth_equal('100 .to_duration 50              - .class ', [XfOOrth::Duration] )
    foorth_equal('100 .to_duration 50 .to_duration - .class ', [XfOOrth::Duration] )

    foorth_equal('100 .to_duration dup 50              - distinct?', [true] )
    foorth_equal('100 .to_duration dup 50 .to_duration - distinct?', [true] )


    foorth_equal('100              50 .to_duration *        ', [5000] )
    foorth_equal('100 .to_duration 50              *        ', [5000] )
    foorth_equal('100 .to_duration 50 .to_duration *        ', [5000] )

    foorth_equal('100              50 .to_duration * .class ', [Fixnum] )
    foorth_equal('100 .to_duration 50              * .class ', [XfOOrth::Duration] )
    foorth_equal('100 .to_duration 50 .to_duration * .class ', [XfOOrth::Duration] )

    foorth_equal('100 .to_duration dup 50              * distinct?', [true] )
    foorth_equal('100 .to_duration dup 50 .to_duration * distinct?', [true] )


    foorth_equal('100              50 .to_duration /        ', [2] )
    foorth_equal('100 .to_duration 50              /        ', [2] )
    foorth_equal('100 .to_duration 50 .to_duration /        ', [2] )

    foorth_equal('100              50 .to_duration / .class ', [Fixnum] )
    foorth_equal('100 .to_duration 50              / .class ', [XfOOrth::Duration] )
    foorth_equal('100 .to_duration 50 .to_duration / .class ', [XfOOrth::Duration] )

    foorth_equal('100 .to_duration dup 50              / distinct?', [true] )
    foorth_equal('100 .to_duration dup 50 .to_duration / distinct?', [true] )

  end

  def test_some_time_to_string
    foorth_equal('1434322206 .to_t .time_s ', [Time.at(1434322206).asctime])

    foorth_equal('10 .to_duration .to_s', ["Duration instance <10.0 seconds>"])
  end

  def test_time_array_stuff
    ofs = Time.now.utc_offset

    foorth_equal('1434322200 .to_t .to_a', [[2015, 6, 14, 18, 50, 0.0, ofs]])

    foorth_equal('[ 2015 6 14 18 50 0.0 -14400 ] .to_t', [Time.at(1434322200)])
    foorth_equal('[ 2015 6 14 18 50 0.0 ] .to_t', [Time.at(1434322200)])
    foorth_equal('[ 2015 6 14 18 50  ] .to_t', [Time.at(1434322200)])
    foorth_equal('[ 2015 6 14 18 ] .to_t', [Time.at(1434322200-(50*60))])
    foorth_equal('[ 2015 6 14 ] .to_t', [Time.at(1434322200-((18*60 + 50)*60))])
    foorth_equal('[ 2015 6 ] .to_t', [Time.at(1434322200-(((13*24 + 18)*60 + 50)*60))])
    foorth_equal('[ 2015 ] .to_t', [Time.at(1434322200-((((151 + 13)*24 + 17)*60 + 50)*60))])

    foorth_equal('[ 2015 15 14 18 50 0.0 -14400 ] .to_t', [nil])

    foorth_equal('[ 2015 6 14 18 50 0.0 -14400 ] .to_t!', [Time.at(1434322200)])
    foorth_raises('[ 2015 15 14 18 50 0.0 -14400 ] .to_t!')
  end

  def test_time_attributes
    foorth_equal('1434322201.5 .to_t .year', [2015])
    foorth_equal('1434322201.5 .to_t .month', [6])
    foorth_equal('1434322201.5 .to_t .day', [14])

    foorth_equal('1434322201.5 .to_t .hour', [18])
    foorth_equal('1434322201.5 .to_t .minute', [50])
    foorth_equal('1434322201.5 .to_t .second', [1])

    foorth_equal('1434322201.5 .to_t .fraction', [0.5])
    foorth_equal('1434322201.5 .to_t .sec_frac', [1.5])

    foorth_equal('1434322201.5 .to_t .offset', [Time.at(1434322201.5).utc_offset])
  end

  def test_time_zone_control
    ofs = Time.now.utc_offset

    foorth_equal('[ 2015 6 14 18 50 0.0 -14400 ] .to_t .utc?', [false])
    foorth_equal('[ 2015 6 14 18 50 0.0      0 ] .to_t .utc?', [true])

    foorth_equal('[ 2015 6 14 18 50 0.0 -14400 ] .to_t .as_utc',
                  [Time.at(1434322200).localtime(0)])

    foorth_equal('[ 2015 6 14 18 50 0.0      0 ] .to_t .as_local',
                  [Time.at(1434322200+ofs)])

    foorth_equal('3600 [ 2015 6 14 18 50 0.0 ] .to_t .as_zone',
                 [Time.at(1434322200).localtime(3600)])

  end

  def test_time_formating
    foorth_equal('1434322201 .to_t f"%A %B %d at %I:%M %p"',
                 ["Sunday June 14 at 06:50 PM"])

    foorth_equal('1434322201 .to_t f"%A %B %d, %r"',
                 ["Sunday June 14, 06:50:01 PM"])

    foorth_equal('1434322201 .to_t f"%A %B %d, %T"',
                 ["Sunday June 14, 18:50:01"])

    foorth_equal('1434322201 .to_t "%A %B %d at %I:%M %p" format',
                 ["Sunday June 14 at 06:50 PM"])

    foorth_equal('1434322201 .to_t "%A %B %d, %r" format',
                 ["Sunday June 14, 06:50:01 PM"])

    foorth_equal('1434322201 .to_t "%A %B %d, %T" format',
                 ["Sunday June 14, 18:50:01"])
  end

  def test_time_parsing
    foorth_equal('"Sunday June 14 at 06:50 PM" Time p"%A %B %d at %I:%M %p"',
                 [Time.at(1434322200)])

    foorth_equal('"Someday June 14 at 06:50 PM" Time p"%A %B %d at %I:%M %p"',
                 [nil])

    foorth_equal('"Sunday June 14 at 06:50 PM" Time p!"%A %B %d at %I:%M %p"',
                 [Time.at(1434322200)])

    foorth_raises('"Someday June 14 at 06:50 PM" Time p!"%A %B %d at %I:%M %p"')


    foorth_equal('"Sunday June 14 at 06:50 PM" Time "%A %B %d at %I:%M %p" parse',
                 [Time.at(1434322200)])

    foorth_equal('"Someday June 14 at 06:50 PM" Time "%A %B %d at %I:%M %p" parse',
                 [nil])

    foorth_equal('"Sunday June 14 at 06:50 PM" Time "%A %B %d at %I:%M %p" parse!',
                 [Time.at(1434322200)])

    foorth_raises('"Someday June 14 at 06:50 PM" Time "%A %B %d at %I:%M %p" parse!')
  end

  def test_some_duration_formatting_support
    foorth_equal('0 .to_duration .largest_interval',   [5])
    foorth_equal('0.1 .to_duration .largest_interval', [5])
    foorth_equal('1 .to_duration .largest_interval',   [5])
    foorth_equal('59 .to_duration .largest_interval',  [5])

    foorth_equal('60 .to_duration .largest_interval',   [4])
    foorth_equal('60.02 .to_duration .largest_interval', [4])
    foorth_equal('120.02 .to_duration .largest_interval', [4])
    foorth_equal('3120.02 .to_duration .largest_interval', [4])
    foorth_equal('3599.99 .to_duration .largest_interval', [4])

    foorth_equal('3600 .to_duration .largest_interval', [3])
    foorth_equal('86399 .to_duration .largest_interval', [3])

    foorth_equal('86400 .to_duration .largest_interval', [2])

    foorth_equal('2629746 .to_duration .largest_interval', [1])

    foorth_equal('31556952 .to_duration .largest_interval', [0])
  end

end
