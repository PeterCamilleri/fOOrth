# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class CtrlStructLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  include MinitestVisible

  def test_if_else_then_constructs
    foorth_equal('1 if "yay" then', ['yay'])
    foorth_equal('false if "yay" then', [])
    foorth_equal('1 if "yay" else "nay" then', ['yay'])
    foorth_equal('nil if "yay" else "nay" then', ['nay'])

    foorth_raises('false if ."yes" else ."no" else ."NO" then ')
  end

  def test_switch_constructs
    foorth_equal('switch 5 end', [5])

    foorth_run(': tsw switch 1 = if "one" break then "other" end ; ')

    foorth_equal(' 1 tsw', ["one"])
    foorth_equal(' 2 tsw', ["other"])
  end

  def test_begin_until_contructs
    foorth_equal('1 begin dup 1 + dup 3 >= until',       [1,2,3])
    foorth_equal('1 begin dup 1 + dup 3 < while again',  [1,2,3])
    foorth_equal('1 begin dup 1 + dup 3 < while repeat', [1,2,3])
  end

  def test_do_loop_contructs
    foorth_equal('1 4 do  i loop',    [1,2,3])
    foorth_equal('1 4 do -i loop',    [3,2,1])

    foorth_equal('1 4 do  i 1 +loop', [1,2,3])
    foorth_equal('1 4 do -i 1 +loop', [3,2,1])

    foorth_equal('1 10 do   i 3 +loop', [1,4,7])
    foorth_equal('1 10 do  -i 3 +loop', [9,6,3])

    foorth_equal('3 10 do   i 3 +loop', [3,6,9])
    foorth_equal('3 10 do  -i 3 +loop', [9,6,3])

    foorth_equal('1 4 do 1 3 do  j loop loop', [1,1,2,2,3,3])
    foorth_equal('1 4 do 1 3 do -j loop loop', [3,3,2,2,1,1])

    foorth_equal('1 4 do 1 3 do i j loop loop', [1,1,2,1,1,2,2,2,1,3,2,3])

    foorth_equal('1 4 do 1 3 do i j * loop loop', [1,2,2,4,3,6])

    foorth_raises('0 10 do  0 +loop')
    foorth_raises('0 10 do -1 +loop')
    foorth_raises('0 10 do "apple" +loop')
  end

  def test_with_constructs
    foorth_equal('4 .with{{ self 2* }}', [8])

    foorth_run(': twc01 4 .with{{ self 2* }} ;')
    foorth_equal('twc01', [8])

    foorth_equal('42 .with{{ self }}', [42])
    foorth_equal('42 .with{{ [ 0 ] .each{{ self }} }}', [42])
    foorth_equal('42 .with{{ 0 1 do self loop }}', [42])
    foorth_equal('42 .with{{ {{ self }} .call }}', [42])
  end

  def test_compile_suspend
    foorth_equal(': tcs [[ 42 ]] ;', [42])
    foorth_raises('[[ ]]')

    foorth_equal(': tcs [[ 42 , ]] ; tcs', [42])
    foorth_raises('42 ,')

    foorth_equal('asm" vm.push(42);" ', [42])
    foorth_equal(': tcs asm" vm.push(42);" ; tcs', [42])

    foorth_equal('"vm.push(42);" .asm ', [42])
    foorth_equal(': tcs "vm.push(42);" .asm ; tcs', [42])
  end

  def test_for_unsupported_structures
    foorth_raises('4 .new{{  }}')
    foorth_raises('4 .each{{  }}')
    foorth_raises('4 .map{{  }}')
    foorth_raises('4 .select{{  }}')
  end

end
