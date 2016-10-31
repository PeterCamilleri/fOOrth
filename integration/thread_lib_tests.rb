# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the fOOrth compile library.
class ThreadLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  include MinitestVisible

  def test_that_thread_classes_exist
    foorth_equal('Thread',    [Thread])
    foorth_equal('Procedure', [Proc])
    foorth_equal('Mutex',     [Mutex])
  end

  def test_that_default_new_is_not_allowed
    foorth_raises('Thread .new')
  end

  def test_the_current_thread
    foorth_equal('Thread .current     .name', ['Thread instance'])
    foorth_equal('Thread .current .vm .name', ['VirtualMachine instance <Main>'])
  end

  def test_the_main_thread
    foorth_equal('Thread .main        .name', ['Thread instance'])
    foorth_equal('Thread .main    .vm .name', ['VirtualMachine instance <Main>'])
  end

  def test_thread_sleeping
    start = Time.now
    foorth_run('0.05 .sleep')
    finish = Time.now
    assert(finish-start > 0.025)
    assert(finish-start < 0.1)
  end

  def test_creating_a_thread
    foorth_equal('0 var$: $tcat1', [])
    foorth_equal('"Test" Thread .new{{ 1 $tcat1 ! }} .join $tcat1 @', [1])
  end

  def test_joining_a_thread
    foorth_output('{{ 0 5 do 0.01 .sleep i . loop }} .start .join ." done"', "01234 done")
  end

  def test_for_poking_with_a_stick
    foorth_equal('{{  }} .start dup .join .alive?', [false])
    foorth_equal('{{ 0.1 .sleep }} .start .alive?', [true])
  end

  def test_thread_status
    foorth_equal('Thread .current                   .status', ['run'])
    foorth_equal('{{            }} .start dup .join .status', ['dead'])
    foorth_equal('{{ 0.1 .sleep }} .start           .status', ['sleep'])
  end

  def test_named_threads
    foorth_equal('"Fred" {{ }} .start_named dup .join .vm .vm_name', ["Fred"])
  end

  def test_some_mutex_stuff
    foorth_run('Mutex .new val$: $tmtx')
    foorth_run('$tmtx .lock $tmtx .unlock ')
    foorth_equal('$tmtx .do{{ 3 4 + }}', [7])

    code = '{{ $tmtx .do{{ 0 10 do $tmtx_str "@" << loop }} }} .start drop ' +
           'begin $tmtx .do{{ $tmtx_str }} "" = while again $tmtx_str'

    10.times do
      foorth_run('""* val$: $tmtx_str')
      foorth_equal(code, ["@"*10])
    end

    code = '{{ Mutex .do{{ 0 10 do $tmtx_str "@" << loop }} }} .start drop ' +
           'begin Mutex .do{{ $tmtx_str }} "" = while again $tmtx_str'

    10.times do
      foorth_run('""* val$: $tmtx_str')
      foorth_equal(code, ["@"*10])
    end
  end

end
