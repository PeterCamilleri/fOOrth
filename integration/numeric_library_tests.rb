# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'

#Test the standard fOOrth library.
class NumericLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Special initialize to track rake progress.
  def initialize(*all)
    $do_this_only_one_time = "" unless defined? $do_this_only_one_time

    if $do_this_only_one_time != __FILE__
      puts
      puts "Running test file: #{File.split(__FILE__)[1]}"
      $do_this_only_one_time = __FILE__
    end

    super(*all)
  end

  def test_some_conversions
    foorth_equal('5    .to_n', [5])
    foorth_equal('5.0  .to_n', [5.0])
    foorth_equal('5/1  .to_n', ['5/1'.to_r])
    foorth_equal('5+0i .to_n', [Complex(5,0)])
    foorth_equal('"xx" .to_n', [nil])

    foorth_equal('5    .to_i', [5])
    foorth_equal('5.0  .to_i', [5])
    foorth_equal('5/1  .to_i', [5])
    foorth_equal('5+0i .to_i', [5])
    foorth_equal('"xx" .to_i', [0])

    foorth_raises('5+3i .to_i', RangeError)

  end

  def test_some_computations
    foorth_equal('5 3 +', [8])
    foorth_equal('5 3 -', [2])
    foorth_equal('5 3 *', [15])
    foorth_equal('5 3 /', [1])
    foorth_equal('5 3 mod', [2])

    foorth_equal('5  neg', [-5])
    foorth_equal('0  neg', [0])
    foorth_equal('-5 neg', [5])

    foorth_equal('5.0  neg', [-5.0])
    foorth_equal('0.0  neg', [0.0])
    foorth_equal('-5.0 neg', [5.0])

    foorth_equal('5 3 <<', [40])
    foorth_equal('40 3 >>', [5])

    foorth_equal('2 10 **', [1024])
    foorth_equal('2.0 .1/x', [0.5])

    foorth_equal(' 2.0 .abs', [2.0])
    foorth_equal('-2.0 .abs', [2.0])

    foorth_equal(' 2.0 .ceil', [2])
    foorth_equal(' 2.1 .ceil', [3])
    foorth_equal(' 2.9 .ceil', [3])

    foorth_equal(' 2.0 .floor', [2])
    foorth_equal(' 2.1 .floor', [2])
    foorth_equal(' 2.9 .floor', [2])

    foorth_equal(' 2.0 .round', [2])
    foorth_equal(' 2.1 .round', [2])
    foorth_equal(' 2.9 .round', [3])

  end

  def test_some_bitwise_ops
    foorth_equal("5 3 and", [1])
    foorth_equal("5 3 or",  [7])
    foorth_equal("5 3 xor", [6])
    foorth_equal("5 com",  [-6])
  end

  def test_some_trig
    foorth_equal("pi", [Math::PI])
    foorth_equal("e",  [Math::E])

    foorth_equal("45 .d2r dup .sin dup * swap .cos dup * + ",  [1.0])

    foorth_equal("1   .asin  .r2d", [90.0])
    foorth_equal("1   .acos  .r2d", [ 0.0])
    foorth_equal("1   .atan  .r2d", [45.0])
    foorth_equal("1 1 .atan2 .r2d", [45.0])

  end

  def test_some_powers
    foorth_equal("0 .e**",     [1.0])
    foorth_equal("1 .ln",      [0.0])

    foorth_equal("2 .10**",    [100.0])
    foorth_equal("100 .log10", [2.0])

    foorth_equal("10 .2**",    [1024.0])
    foorth_equal("1024 .log2", [10.0])

    foorth_equal("1024 .sqrt", [32.0])
    foorth_equal("8    .cbrt", [ 2.0])

    foorth_equal("3 4 .hypot", [5.0])
  end

end
