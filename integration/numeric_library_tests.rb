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
  end

  def test_some_bitwise_ops
    foorth_equal("5 3 and", [1])
    foorth_equal("5 3 or",  [7])
    foorth_equal("5 3 xor", [6])
    foorth_equal("5 com",  [-6])
  end

end
