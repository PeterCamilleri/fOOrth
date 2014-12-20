# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class VMLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_that_the_VM_class_and_instance_are_available
    foorth_equal("VirtualMachine", [XfOOrth::VirtualMachine])

    vm = Thread.current[:vm]
    foorth_equal("vm", [vm])

  end

  def test_for_the_vm_name
    foorth_equal("vm .vm_name", ['Main'])
  end

end
