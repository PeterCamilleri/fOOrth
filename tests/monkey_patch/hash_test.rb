# coding: utf-8

require_relative '../../lib/fOOrth/monkey_patch/object'
require          'minitest/autorun'

#Test the monkey patches applied to the Object class.
class HashMonkeyPatchTester < MiniTest::Unit::TestCase

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

  def test_to_pointer
    assert_equal({0 => 'foo'}.to_foorth_p, {0 => 'foo'})
  end

end
