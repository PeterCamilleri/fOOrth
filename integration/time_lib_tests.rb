# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the fOOrth compile library.
class TimeLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_that_the_time_class_exists
    foorth_equal('Time', [Time])
  end

  def test_that_new_not_allowed
    foorth_raises('Time .new')
  end

  def test_some_time_macros
    foorth_equal('now .class', [Time])
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

    foorth_equal('1434322206 .to_t  1434322200 .to_t <=>', [1])
    foorth_equal('1434322206 .to_t  1434322206 .to_t <=>', [0])
    foorth_equal('1434322200 .to_t  1434322206 .to_t <=>', [-1])
  end


end
