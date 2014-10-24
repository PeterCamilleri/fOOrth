# coding: utf-8

require_relative '../lib/foorth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'

#Test the fOOrth compile library.
class CompileLibraryTester < MiniTest::Unit::TestCase

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


  def test_creating_simple_words
    foorth_equal(': dbl dup + ; 4 dbl', [8])
    foorth_equal('9 dbl', [18])
  end

  def test_simple_word_override
    foorth_equal(': foo 3 * ; 4 foo', [12])
    foorth_equal('5 foo', [15])
    foorth_equal(': foo 4 * ; 4 foo', [16])
    foorth_equal('5 foo', [20])
  end

  def test_creating_methods
    foorth_equal('Numeric :: .dbl self dup + ; 4 .dbl', [8])
    foorth_equal('9 .dbl', [18])
  end

  def test_methods_override
    foorth_equal('Numeric :: .foo self 3 * ; 4 .foo', [12])
    foorth_equal('5 .foo', [15])
    foorth_equal('Numeric :: .foo self 4 * ; 4 .foo', [16])
    foorth_equal('5 .foo', [20])
  end

end
