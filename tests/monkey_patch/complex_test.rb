# coding: utf-8

gem              'minitest'
require          'minitest/autorun'
require_relative '../../lib/fOOrth/monkey_patch/numeric'
require_relative '../../lib/fOOrth/monkey_patch/complex'

#Test the monkey patches applied to the Object class.
class ComplexMonkeyPatchTester < MiniTest::Test

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

  #Test that it embeds
  def test_embed
    comp = Complex(1,2)
    assert_equal(comp.embed, 'Complex(1,2)')
  end

end