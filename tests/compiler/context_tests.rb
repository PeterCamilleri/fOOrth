# coding: utf-8

require_relative '../../lib/fOOrth/exceptions'
require_relative '../../lib/fOOrth/monkey_patch/object'
require_relative '../../lib/fOOrth/symbol_map'
require_relative '../../lib/fOOrth/compiler/context'
require          'minitest/autorun'

#Test the monkey patches applied to the Object class.
class ContextTester < MiniTest::Unit::TestCase

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




end