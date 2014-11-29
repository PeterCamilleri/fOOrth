# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'

#Test the standard fOOrth numeric (and related) library.
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

    foorth_equal('5 .to_x', [Complex(5,0)])

    foorth_equal('5 .real',          [5])
    foorth_equal('5 .imaginary',     [0])

    foorth_equal('5+7i .real',       [5])
    foorth_equal('5+7i .imaginary',  [7])

    foorth_equal('3 .magnitude',     [3])
    foorth_equal('3 .angle .r2d',    [0])
    foorth_equal('-3 .angle .r2d',   [180])

    foorth_equal('3+4i .magnitude',  [5])
    foorth_equal('1+1i .angle .r2d', [45.0])

    foorth_equal('42   .conjugate',  [42])
    foorth_equal('1+1i .conjugate',  [Complex(1,-1)])

    foorth_equal('1+1i .polar .r2d', [Math.sqrt(2.0), 45.0])
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

    foorth_equal(' 1.5 .numerator',   [3])
    foorth_equal(' 1.5 .denominator', [2])

    foorth_equal(' 3/2 .numerator',   [3])
    foorth_equal(' 3/2 .denominator', [2])

  end

  def test_some_bitwise_ops
    foorth_equal("5 3 and", [1])
    foorth_equal("5 3 or",  [7])
    foorth_equal("5 3 xor", [6])
    foorth_equal("5 com",  [-6])
  end

  def test_some_trig
    foorth_equal("pi",  [Math::PI])
    foorth_equal("e",   [Math::E])
    foorth_equal("dpr", [XfOOrth::DegreesPerRadian])

    foorth_equal("45 .d2r dup .sin dup * swap .cos dup * + ",  [1.0])

    foorth_equal("1   .asin  .r2d", [90.0])
    foorth_equal("1   .acos  .r2d", [ 0.0])
    foorth_equal("1   .atan  .r2d", [45.0])
    foorth_equal("1 1 .atan2 .r2d", [45.0])

  end

  def test_some_powers
    foorth_equal("0    .e**",   [1.0])
    foorth_equal("1    .ln",    [0.0])
    foorth_equal("e    .ln",    [1.0])

    foorth_equal("2    .10**",  [100.0])
    foorth_equal("100  .log10", [2.0])

    foorth_equal("10   .2**",   [1024.0])
    foorth_equal("1024 .log2",  [10.0])

    foorth_equal("16   .sqr ",  [256])
    foorth_equal("16   .cube",  [4096])

    foorth_equal("16.0 .sqr ",  [256.0])
    foorth_equal("16.0 .cube",  [4096.0])

    foorth_equal("1024 .sqrt",  [32.0])
    foorth_equal("8    .cbrt",  [ 2.0])
    foorth_equal("64   .cbrt",  [ 4.0])

    foorth_equal("3 4  .hypot", [5.0])
  end

  def test_some_integer_ops
    foorth_equal("100 64   .gcd",   [4])
    foorth_equal("100 64   .lcm",   [1600])

    foorth_equal("100      .even?", [true])
    foorth_equal("101      .even?", [false])
    foorth_equal("16666600 .even?", [true])
    foorth_equal("16666601 .even?", [false])

    foorth_equal("100      .odd?",  [false])
    foorth_equal("101      .odd?",  [true])
    foorth_equal("16666600 .odd?",  [false])
    foorth_equal("16666601 .odd?",  [true])

  end

  def test_being_rational
    foorth_equal("1 2 rational", ['1/2'.to_r])
    foorth_equal("1/2 .split",   [1, 2])
  end

  def test_being_complex
    foorth_equal("1 2 complex", [Complex(1,2)])
    foorth_equal("1+2i .split",   [1, 2])
  end

  def test_the_polar_vortex
    foorth_equal("1  1 .c2p .r2d", [Math::sqrt(2.0), 45.0])
    #foorth_equal("2.0 .sqrt 45 .d2r .p2c", [1.0, 1.0])
  end

end
