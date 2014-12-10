# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'

#Test the standard fOOrth library.
class CtrlStructLibraryTester < MiniTest::Unit::TestCase

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

  def test_if_else_then_constructs
    foorth_equal('1 if "yay" then', ['yay'])
    foorth_equal('false if "yay" then', [])
    foorth_equal('1 if "yay" else "nay" then', ['yay'])
    foorth_equal('nil if "yay" else "nay" then', ['nay'])
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

  def test_for_unsupported_structures
    foorth_raises('4 .new{   }' )
    foorth_raises('4 .each{   }')
    foorth_raises('4 .map{   }')
  end

end
