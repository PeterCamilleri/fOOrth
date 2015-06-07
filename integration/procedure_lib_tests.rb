# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class ProcedureLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_lambda_basics
    foorth_equal("{{   }} .name ", ["Procedure instance"])
  end

  def test_calling_lambdas
    foorth_equal("1 {{ 99 + }} .call ", [100])
  end

  def test_creating_a_thread
    foorth_run('0 var$: $tcat2')
    foorth_equal('{{ 1 $tcat2 ! }} .start drop 0.01 .sleep $tcat2 @', [1])
  end

  def test_calling_with
    foorth_equal('4 {{ self dup + }} .call_with', [8])
  end

end
