# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class CloneLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_some_cloning_around
    foorth_equal("33 clone", [33,33])
    foorth_equal("33 .clone", [33])

    foorth_equal("33 clone identical?", [true])
    foorth_equal("33 clone distinct?", [false])

    foorth_equal('"33" clone identical?', [false])
    foorth_equal('"33" clone distinct?', [true])

    foorth_equal('"33" dup .clone identical?', [false])
    foorth_equal('"33" dup .clone distinct?', [true])

    foorth_equal('[ "33" ] clone distinct?', [true])
    foorth_equal('[ "33" ] clone @ swap @ distinct?', [true])

  end

  def test_some_clone_exclusion
    foorth_run('class: Tscx')
    foorth_run('Tscx .: .init "a" val@: @a "b" val@: @b ;')
    foorth_run('Tscx .: .a @a ;')
    foorth_run('Tscx .: .b @b ;')
    foorth_run('Tscx .: .clone_exclude [ "@b" ] ;')
    foorth_run('Tscx .new val$: $tscx1')
    foorth_run('$tscx1 .clone val$: $tscx2')

    foorth_equal('$tscx1 .clone_exclude', [["@b"]])

    foorth_equal('$tscx1 .a', ["a"])
    foorth_equal('$tscx1 .b', ["b"])
    foorth_equal('$tscx2 .a', ["a"])
    foorth_equal('$tscx2 .b', ["b"])

    foorth_run('$tscx1 .a "1" <<')
    foorth_run('$tscx1 .b "1" <<')

    foorth_equal('$tscx1 .a', ["a1"])
    foorth_equal('$tscx1 .b', ["b1"])
    foorth_equal('$tscx2 .a', ["a"])
    foorth_equal('$tscx2 .b', ["b1"])

  end

  def test_some_copying_too
    foorth_equal("33 copy", [33,33])
    foorth_equal("33 .copy", [33])

    foorth_equal('"33" copy identical?', [false])
    foorth_equal('"33" copy distinct?', [true])

    foorth_equal('[ "33" ] copy distinct?', [true])
    foorth_equal('[ "33" ] copy @ swap @ distinct?', [false])
  end

end