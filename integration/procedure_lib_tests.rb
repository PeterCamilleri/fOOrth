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
  include MinitestVisible

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

  def test_calling_x_v_and_vx
    foorth_equal('4 {{ v dup + }} .call_v', [8])
    foorth_equal('4 {{ x dup + }} .call_x', [8])

    foorth_equal('5 4 {{ v x 2dup + }} .call_vx', [5, 4, 9])
  end

  def test_local_data
    foorth_equal('{{ 42 val: a a   }} .call', [42])
    foorth_equal('{{ 42 var: a a @ }} .call', [42])
  end

  def test_instance_data
    foorth_run('42 Object .new .with{{ val@: @test self val$: $t_i_d_1 }}')
    foorth_run('$t_i_d_1  .:: .mulby @test * ; ')
    foorth_equal('2 $t_i_d_1 .mulby', [84])

    foorth_run('99 $t_i_d_1 .with{{ var@: @boot }} ')
    foorth_run('$t_i_d_1  .:: .addby @boot @ + ; ')
    foorth_equal('2 $t_i_d_1 .addby', [101])

    foorth_run('$t_i_d_1 .:: .set_boot @boot ! ;')
    foorth_run('56 $t_i_d_1 .set_boot')
    foorth_equal('2 $t_i_d_1 .addby', [58])
  end
end
