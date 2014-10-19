# coding: utf-8

require_relative './foorth_testing'
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

  def test_a_bunch_o_stack_stuff
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

end

