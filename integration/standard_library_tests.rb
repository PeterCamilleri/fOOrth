# coding: utf-8

require_relative '../lib/foorth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'

#Test the standard fOOrth library.
class StandardLibraryTester < MiniTest::Unit::TestCase

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

  def test_basic_constants
    foorth_equal("self", [XfOOrth.virtual_machine])
    foorth_equal("true", [true])
    foorth_equal("false", [false])
    foorth_equal("nil", [nil])
  end

  def test_stack_manipulation
    foorth_equal("1 2 drop", [1])

    foorth_equal("33 dup", [33,33])

    foorth_equal("false ?dup", [false])
    foorth_equal("nil ?dup", [nil])
    foorth_equal('"" ?dup', [""])
    foorth_equal("0 ?dup", [0])

    foorth_equal("true  ?dup", [true, true])
    foorth_equal('"A" ?dup', ["A", "A"])
    foorth_equal("1 ?dup", [1,1])

    foorth_equal("1 2 swap", [2,1])

    foorth_equal("1 2 3 rot", [2,3,1])

    foorth_equal("1 2 over", [1,2,1])

    foorth_equal("1 2 3 1 pick", [1,2,3,3])
    foorth_equal("1 2 3 2 pick", [1,2,3,2])
    foorth_equal("1 2 3 3 pick", [1,2,3,1])

    foorth_equal("1 2 nip", [2])

    foorth_equal("1 2 tuck", [2,1,2])
  end

  def test_some_computations
    foorth_equal('5 3 +', [8])
    foorth_equal('5 3 -', [2])
    foorth_equal('5 3 *', [15])
    foorth_equal('5 3 /', [1])
    foorth_equal('5 3 mod', [2])
  end

  def test_some_comparisons
    foorth_equal('4 4 =', [true])
    foorth_equal('4 5 =', [false])

    foorth_equal('4 4 <>', [false])
    foorth_equal('4 5 <>', [true])

    foorth_equal('4 4  >', [false])
    foorth_equal('4 5  >', [false])
    foorth_equal('5 4  >', [true])

    foorth_equal('4 4  <', [false])
    foorth_equal('4 5  <', [true])
    foorth_equal('5 4  <', [false])

    foorth_equal('4 4 >=', [true])
    foorth_equal('4 5 >=', [false])
    foorth_equal('5 4 >=', [true])

    foorth_equal('4 4 <=', [true])
    foorth_equal('4 5 <=', [true])
    foorth_equal('5 4 <=', [false])

    foorth_equal('4 4 <=>', [0])
    foorth_equal('4 5 <=>', [-1])
    foorth_equal('5 4 <=>', [1])
  end

  def test_some_comparisons_with_zero
    foorth_equal('-2 0=', [false])
    foorth_equal('0  0=', [true])
    foorth_equal('4  0=', [false])

    foorth_equal('-4 0<>', [true])
    foorth_equal('0  0<>', [false])
    foorth_equal('5  0<>', [true])

    foorth_equal('-1 0>', [false])
    foorth_equal('0  0>', [false])
    foorth_equal('4  0>', [true])

    foorth_equal('4  0<', [false])
    foorth_equal('-5 0<', [true])
    foorth_equal('0  0<', [false])

    foorth_equal('4  0>=', [true])
    foorth_equal('-5 0>=', [false])
    foorth_equal('0  0>=', [true])

    foorth_equal('-4 0<=', [true])
    foorth_equal('0  0<=', [true])
    foorth_equal('4  0<=', [false])

    foorth_equal('0  0<=>', [0])
    foorth_equal('-5 0<=>', [-1])
    foorth_equal('4  0<=>', [1])
  end

  def test_if_else_then_constructs
    foorth_equal('1 if "yay" then', ['yay'])
    foorth_equal('0 if "yay" then', [])
    foorth_equal('1 if "yay" else "nay" then', ['yay'])
    foorth_equal('0 if "yay" else "nay" then', ['nay'])
  end

  def test_begin_until_contructs
    foorth_equal('1 begin dup 1 + dup 3 >= until',       [1,2,3])
    foorth_equal('1 begin dup 1 + dup 3 < while again',  [1,2,3])
    foorth_equal('1 begin dup 1 + dup 3 < while repeat', [1,2,3])
  end

  def test_do_loop_contructs
    foorth_equal('1 4 do  i loop',    [1,2,3])
    foorth_equal('1 4 do -i loop',    [3,2,1])

    foorth_equal('1 4 do  i 1 +loop', [1,2,3])
    foorth_equal('1 4 do -i 1 +loop', [3,2,1])

    foorth_equal('1 10 do   i 3 +loop', [1,4,7])
    foorth_equal('1 10 do  -i 3 +loop', [9,6,3])

    foorth_equal('3 10 do   i 3 +loop', [3,6,9])
    foorth_equal('3 10 do  -i 3 +loop', [9,6,3])

    foorth_equal('1 4 do 1 3 do  j loop loop', [1,1,2,2,3,3])
    foorth_equal('1 4 do 1 3 do -j loop loop', [3,3,2,2,1,1])

    foorth_equal('1 4 do 1 3 do i j loop loop', [1,1,2,1,1,2,2,2,1,3,2,3])

    foorth_equal('1 4 do 1 3 do i j * loop loop', [1,2,2,4,3,6])
  end

end
