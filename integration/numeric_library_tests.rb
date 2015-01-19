# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth numeric (and related) library.
class NumericLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_some_extreme_numbers
    foorth_equal('max_num', [MaxNumeric])
    foorth_equal('min_num', [MinNumeric])
  end

  def test_some_comparisons
    foorth_equal('4       4       =  ', [true])
    foorth_equal('4       5       =  ', [false])
    foorth_equal('max_num 4       =  ', [false])
    foorth_equal('4       max_num =  ', [false])
    foorth_equal('max_num max_num =  ', [true])
    foorth_equal('min_num 4       =  ', [false])
    foorth_equal('4       min_num =  ', [false])
    foorth_equal('min_num min_num =  ', [true])
    foorth_equal('max_num min_num =  ', [false])
    foorth_equal('min_num max_num =  ', [false])

    foorth_equal('4       4       <> ', [false])
    foorth_equal('4       5       <> ', [true])
    foorth_equal('max_num 4       <> ', [true])
    foorth_equal('4       max_num <> ', [true])
    foorth_equal('max_num max_num <> ', [false])
    foorth_equal('min_num 4       <> ', [true])
    foorth_equal('4       min_num <> ', [true])
    foorth_equal('min_num min_num <> ', [false])
    foorth_equal('max_num min_num <> ', [true])
    foorth_equal('min_num max_num <> ', [true])

  end

  def test_some_comparisons_with_zero
    foorth_equal('-2       0=  ', [false])
    foorth_equal('0        0=  ', [true])
    foorth_equal('4        0=  ', [false])
    foorth_equal('max_num  0=  ', [false])
    foorth_equal('min_num  0=  ', [false])

    foorth_equal('-4       0<> ', [true])
    foorth_equal('0        0<> ', [false])
    foorth_equal('5        0<> ', [true])
    foorth_equal('max_num  0<> ', [true])
    foorth_equal('min_num  0<> ', [true])

    foorth_equal('-1       0>  ', [false])
    foorth_equal('0        0>  ', [false])
    foorth_equal('4        0>  ', [true])
    foorth_equal('max_num  0>  ', [true])
    foorth_equal('min_num  0>  ', [false])

    foorth_equal('4        0<  ', [false])
    foorth_equal('-5       0<  ', [true])
    foorth_equal('0        0<  ', [false])
    foorth_equal('max_num  0<  ', [false])
    foorth_equal('min_num  0<  ', [true])

    foorth_equal('4        0>= ', [true])
    foorth_equal('-5       0>= ', [false])
    foorth_equal('0        0>= ', [true])
    foorth_equal('max_num  0>= ', [true])
    foorth_equal('min_num  0>= ', [false])

    foorth_equal('-4       0<= ', [true])
    foorth_equal('0        0<= ', [true])
    foorth_equal('4        0<= ', [false])
    foorth_equal('max_num  0<= ', [false])
    foorth_equal('min_num  0<= ', [true])

    foorth_equal('0        0<=>', [0])
    foorth_equal('-5       0<=>', [-1])
    foorth_equal('4        0<=>', [1])
    foorth_equal('max_num  0<=>', [1])
    foorth_equal('min_num  0<=>', [-1])
  end

  def test_some_min_max_exclusions
    foorth_raises('max_num .to_i')
    foorth_raises('min_num .to_i')

    foorth_raises('max_num 1 +')
    foorth_raises('1 max_num +')
    foorth_raises('min_num 1 +')
    foorth_raises('1 min_num +')

    foorth_raises('max_num 1 -')
    foorth_raises('1 max_num -')
    foorth_raises('min_num 1 -')
    foorth_raises('1 min_num -')

    foorth_raises('max_num 1 *')
    foorth_raises('1 max_num *')
    foorth_raises('min_num 1 *')
    foorth_raises('1 min_num *')

    foorth_raises('max_num 1 /')
    foorth_raises('1 max_num /')
    foorth_raises('min_num 1 /')
    foorth_raises('1 min_num /')

    foorth_raises('max_num 1 **')
    foorth_raises('1 max_num **')
    foorth_raises('min_num 1 **')
    foorth_raises('1 min_num **')

    foorth_raises('max_num 1 mod')
    foorth_raises('1 max_num mod')
    foorth_raises('min_num 1 mod')
    foorth_raises('1 min_num mod')
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

    foorth_raises('"xx" .to_i')
    foorth_raises('5+3i .to_i')

    foorth_equal('"2.0"   .to_f ', [2.0])
    foorth_equal('"apple" .to_f ', [nil])
    foorth_raises('"apple" .to_f!')

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
    foorth_raises('1+1i 3 mod')
    foorth_raises('3 1+1i mod')

    foorth_equal('5 "3" +', [8])
    foorth_equal('5 "3" -', [2])
    foorth_equal('5 "3" *', [15])
    foorth_equal('5 "3" /', [1])
    foorth_equal('5 "3" mod', [2])

    foorth_equal('5  neg', [-5])
    foorth_equal('0  neg', [0])
    foorth_equal('-5 neg', [5])

    foorth_equal('5.0  neg', [-5.0])
    foorth_equal('0.0  neg', [0.0])
    foorth_equal('-5.0 neg', [5.0])
    foorth_equal('max_num neg', [MinNumeric])
    foorth_equal('min_num neg', [MaxNumeric])

    foorth_equal('5 3 <<', [40])
    foorth_equal('40 3 >>', [5])

    foorth_equal('2 10 **', [1024])
    foorth_equal('2.0 .1/x', [0.5])
    foorth_equal('max_num .1/x', [0])
    foorth_equal('min_num .1/x', [0])

    foorth_equal(' 2.0 .abs', [2.0])
    foorth_equal('-2.0 .abs', [2.0])
    foorth_equal('max_num .abs', [MaxNumeric])
    foorth_equal('min_num .abs', [MaxNumeric])

    foorth_equal(' 2.0 .ceil', [2])
    foorth_equal(' 2.1 .ceil', [3])
    foorth_equal(' 2.9 .ceil', [3])
    foorth_raises('1+1i .ceil')

    foorth_equal(' 2.0 .floor', [2])
    foorth_equal(' 2.1 .floor', [2])
    foorth_equal(' 2.9 .floor', [2])
    foorth_raises('1+1i .floor')

    foorth_equal(' 2.0 .round', [2])
    foorth_equal(' 2.1 .round', [2])
    foorth_equal(' 2.9 .round', [3])
    foorth_raises('1+1i .round')

    foorth_equal(' 1.5 .numerator',   [3])
    foorth_equal(' 1.5 .denominator', [2])

    foorth_equal(' 3/2 .numerator',   [3])
    foorth_equal(' 3/2 .denominator', [2])

  end

  def test_some_bitwise_ops
    foorth_equal("5 3 and", [1])
    foorth_equal("5 3 or",  [7])
    foorth_equal("5 3 xor", [6])
    foorth_equal("5   com", [-6])

    foorth_equal("5 3 <<", [40])
    foorth_equal("40 3 >>", [5])

  end

  def test_some_trig
    foorth_equal("pi",  [Math::PI])
    foorth_equal("e",   [Math::E])
    foorth_equal("dpr", [XfOOrth::DegreesPerRadian])

    foorth_equal("45 .d2r dup .sin dup * swap .cos dup * + ",  [1.0])

    foorth_equal("0   .tan       ", [0.0])

    foorth_equal("1   .asin  .r2d", [90.0])
    foorth_equal("1   .acos  .r2d", [ 0.0])
    foorth_equal("1   .atan  .r2d", [45.0])
    foorth_equal("1 1 .atan2 .r2d", [45.0])

    foorth_raises('1+1i .sin')
    foorth_raises('1+1i .cos')
    foorth_raises('1+1i .tan')
    foorth_raises('1+1i .asin')
    foorth_raises('1+1i .acos')
    foorth_raises('1+1i .atan')
    foorth_raises('1+1i 3 .atan2')
    foorth_raises('1 1+1i .atan2')
  end

  def test_some_exagerated_trig
    foorth_equal("0   .sinh      ", [0.0])
    foorth_equal("0   .cosh      ", [1.0])
    foorth_equal("0   .tanh      ", [0.0])

    foorth_equal("0   .asinh     ", [0.0])
    foorth_equal("1   .acosh     ", [0.0])
    foorth_equal("0   .atanh     ", [0.0])

    foorth_raises('1+1i .sinh')
    foorth_raises('1+1i .cosh')
    foorth_raises('1+1i .tanh')
    foorth_raises('1+1i .asinh')
    foorth_raises('1+1i .acosh')
    foorth_raises('1+1i .atanh')
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
    foorth_equal("16.0 .sqr ",  [256.0])
    foorth_equal("1+1i .sqr ",  [Complex(0,2)])
    foorth_equal("16   .cube",  [4096])
    foorth_equal("16.0 .cube",  [4096.0])
    foorth_equal("1+1i .cube",  [Complex(-2,2)])

    foorth_equal("1024 .sqrt",  [32.0])
    foorth_equal("0+1i .sqrt",  [Complex(0.7071067811865476, 0.7071067811865475)])

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

  def test_short_cut_methods
    foorth_equal('10   1+' , [11])
    foorth_equal('10   1-' , [9])

    foorth_equal('10   2+' , [12])
    foorth_equal('10   2-' , [8])

    foorth_equal('10   2*' , [20])
    foorth_equal('10   2/' , [5])

    foorth_equal('10.0 1+' , [11.0])
    foorth_equal('10.0 1-' , [9.0])

    foorth_equal('10.0 2+' , [12.0])
    foorth_equal('10.0 2-' , [8.0])

    foorth_equal('10.0 2*' , [20.0])
    foorth_equal('10.0 2/' , [5.0])
  end


end
