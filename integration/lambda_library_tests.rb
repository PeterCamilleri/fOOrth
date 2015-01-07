# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class ProcedureLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_lambda_basics
    foorth_equal("{{   }} .name ", ["Procedure instance"])
  end

  def test_calling_lambdas
    foorth_equal("1 {{ 99 + }} .call ", [100])
  end


end
