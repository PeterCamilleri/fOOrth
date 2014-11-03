# coding: utf-8

gem              'minitest'
require          'minitest/autorun'
require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'

#Test the standard fOOrth library.
class VMLibraryTester < MiniTest::Test

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

  def test_that_the_VM_class_and_instance_are_available
    foorth_equal("VirtualMachine", [XfOOrth::VirtualMachine])

    vm = XfOOrth.virtual_machine
    foorth_equal("vm", [vm])
  end


end
