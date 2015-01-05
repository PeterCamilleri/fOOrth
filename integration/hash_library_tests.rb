# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class HashLibraryTester < MiniTest::Unit::TestCase

  include XfOOrthTestExtensions

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_some_hash_basics
    foorth_equal('       Hash                    ', [Hash])

    foorth_equal('       Hash .new               ', [{}])

    foorth_equal(' {                    }        ', [{}])
    foorth_equal(' { 4 "A" ->  5 "B" -> }        ', [{4=>"A", 5=>"B"}], true)
  end



end