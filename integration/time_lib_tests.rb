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

  def test_some_time_macros
    foorth_equal('now .class', [Time])
    foorth_equal('local_offset', [Time.now.utc_offset])
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

  def test_time_comparisons
    foorth_equal('1434322206 .to_t  1434322200 .to_t >  ', [true])
    foorth_equal('1434322206 .to_t  1434322200 .to_t >= ', [true])
    foorth_equal('1434322206 .to_t  1434322200 .to_t <  ', [false])
    foorth_equal('1434322206 .to_t  1434322200 .to_t <= ', [false])

    foorth_equal('1434322206 .to_t  1434322200 .to_t =  ', [false])
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
    foorth_equal('1434322206 .to_t 1434322206 .to_t - ', [0])
    foorth_raises('1434322206 .to_t "apple"  - ')
  end

  def test_some_time_to_string
    foorth_equal('1434322206 .to_t .time_s ', [Time.at(1434322206).asctime])
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

end
