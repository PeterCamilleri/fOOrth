# coding: utf-8

require_relative '../../lib/fOOrth/monkey_patch'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the coerce protocol.
class CoerceProtocolTester < MiniTest::Unit::TestCase

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  #Test the default stubs.
  def test_object_stubs
    obj = Object.new

    assert_raises(XfOOrth::XfOOrthError) { obj.foorth_coerce(42) }
    assert_raises(XfOOrth::XfOOrthError) { obj.foorth_mnmx_coerce(42) }
  end

  def test_coerce_for_integers
    obj = Object.new

    assert_equal(42, (3).foorth_coerce(42))
    assert_equal(Fixnum, (3).foorth_coerce(42).class)

    assert_equal(42, (3).foorth_coerce('42'))
    assert_equal(Fixnum, (3).foorth_coerce('42').class)

    assert_raises(XfOOrth::XfOOrthError) { (3).foorth_coerce('turnip') }
    assert_raises(XfOOrth::XfOOrthError) { (3).foorth_coerce(obj) }
    assert_raises(XfOOrth::XfOOrthError) { (3).foorth_coerce(nil) }
    assert_raises(XfOOrth::XfOOrthError) { (3).foorth_coerce(MaxNumeric) }
    assert_raises(XfOOrth::XfOOrthError) { (3).foorth_coerce(MinNumeric) }

    assert_equal(42, (3).foorth_mnmx_coerce(42))
    assert_equal(Fixnum, (3).foorth_mnmx_coerce(42).class)

    assert_equal(42, (3).foorth_mnmx_coerce('42'))
    assert_equal(Fixnum, (3).foorth_mnmx_coerce('42').class)

    assert_equal(MaxNumeric, (3).foorth_mnmx_coerce(MaxNumeric))
    assert_equal(MinNumeric, (3).foorth_mnmx_coerce(MinNumeric))

    assert_raises(XfOOrth::XfOOrthError) { (3).foorth_mnmx_coerce('turnip') }
    assert_raises(XfOOrth::XfOOrthError) { (3).foorth_mnmx_coerce(obj) }
    assert_raises(XfOOrth::XfOOrthError) { (3).foorth_mnmx_coerce(nil) }

  end

  def test_coerce_for_floats
    obj = Object.new

    assert_equal(42.0, (3.0).foorth_coerce(42))
    assert_equal(Float, (3.0).foorth_coerce(42).class)

    assert_equal(42.0, (3.0).foorth_coerce(42.0))
    assert_equal(Float, (3.0).foorth_coerce(42.0).class)

    assert_equal(42.0, (3.0).foorth_coerce('42'))
    assert_equal(Float, (3.0).foorth_coerce('42').class)

    assert_equal(42.0, (3.0).foorth_coerce('42.0'))
    assert_equal(Float, (3.0).foorth_coerce('42.0').class)

    assert_raises(XfOOrth::XfOOrthError) { (3.0).foorth_coerce('turnip') }
    assert_raises(XfOOrth::XfOOrthError) { (3.0).foorth_coerce(obj) }
    assert_raises(XfOOrth::XfOOrthError) { (3.0).foorth_coerce(nil) }
    assert_raises(XfOOrth::XfOOrthError) { (3.0).foorth_coerce(MaxNumeric) }
    assert_raises(XfOOrth::XfOOrthError) { (3.0).foorth_coerce(MinNumeric) }

    assert_equal(42.0, (3.0).foorth_mnmx_coerce(42))
    assert_equal(Float, (3.0).foorth_mnmx_coerce(42).class)

    assert_equal(42.0, (3.0).foorth_mnmx_coerce('42'))
    assert_equal(Float, (3.0).foorth_mnmx_coerce('42').class)

    assert_equal(MaxNumeric, (3.0).foorth_mnmx_coerce(MaxNumeric))
    assert_equal(MinNumeric, (3.0).foorth_mnmx_coerce(MinNumeric))

    assert_raises(XfOOrth::XfOOrthError) { (3.0).foorth_mnmx_coerce('turnip') }
    assert_raises(XfOOrth::XfOOrthError) { (3.0).foorth_mnmx_coerce(obj) }
    assert_raises(XfOOrth::XfOOrthError) { (3.0).foorth_mnmx_coerce(nil) }

  end

  def test_coerce_for_rationals
    obj = Object.new

    assert_equal('42/1'.to_r, ('3/1'.to_r).foorth_coerce(42))
    assert_equal(Rational, ('3/1'.to_r).foorth_coerce(42).class)

    assert_equal('42/1'.to_r, ('3/1'.to_r).foorth_coerce(42.0))
    assert_equal(Rational, ('3/1'.to_r).foorth_coerce(42.0).class)

    assert_equal('42/1'.to_r, ('3/1'.to_r).foorth_coerce('42'))
    assert_equal(Rational, ('3/1'.to_r).foorth_coerce('42').class)

    assert_equal('42/1'.to_r, ('3/1'.to_r).foorth_coerce('42.0'))
    assert_equal(Rational, ('3/1'.to_r).foorth_coerce('42.0').class)

    assert_equal('42/1'.to_r, ('3/1'.to_r).foorth_coerce('42/1'))
    assert_equal(Rational, ('3/1'.to_r).foorth_coerce('42/1').class)

    assert_raises(XfOOrth::XfOOrthError) { ('3/1'.to_r).foorth_coerce('turnip') }
    assert_raises(XfOOrth::XfOOrthError) { ('3/1'.to_r).foorth_coerce(obj) }
    assert_raises(XfOOrth::XfOOrthError) { ('3/1'.to_r).foorth_coerce(nil) }
    assert_raises(XfOOrth::XfOOrthError) { ('3/1'.to_r).foorth_coerce(MaxNumeric) }
    assert_raises(XfOOrth::XfOOrthError) { ('3/1'.to_r).foorth_coerce(MinNumeric) }

    assert_equal('42/1'.to_r, ('3/1'.to_r).foorth_mnmx_coerce(42))
    assert_equal(Rational, ('3/1'.to_r).foorth_mnmx_coerce(42).class)

    assert_equal('42/1'.to_r, ('3/1'.to_r).foorth_mnmx_coerce(42.0))
    assert_equal(Rational, ('3/1'.to_r).foorth_mnmx_coerce(42.0).class)

    assert_equal('42/1'.to_r, ('3/1'.to_r).foorth_mnmx_coerce('42'))
    assert_equal(Rational, ('3/1'.to_r).foorth_mnmx_coerce('42').class)

    assert_equal('42/1'.to_r, ('3/1'.to_r).foorth_mnmx_coerce('42.0'))
    assert_equal(Rational, ('3/1'.to_r).foorth_mnmx_coerce('42.0').class)

    assert_equal('42/1'.to_r, ('3/1'.to_r).foorth_mnmx_coerce('42/1'))
    assert_equal(Rational, ('3/1'.to_r).foorth_mnmx_coerce('42/1').class)

    assert_equal(MaxNumeric, ('3/1'.to_r).foorth_mnmx_coerce(MaxNumeric))
    assert_equal(MinNumeric, ('3/1'.to_r).foorth_mnmx_coerce(MinNumeric))

    assert_raises(XfOOrth::XfOOrthError) { ('3/1'.to_r).foorth_mnmx_coerce('turnip') }
    assert_raises(XfOOrth::XfOOrthError) { ('3/1'.to_r).foorth_mnmx_coerce(obj) }
    assert_raises(XfOOrth::XfOOrthError) { ('3/1'.to_r).foorth_mnmx_coerce(nil) }

  end


end
