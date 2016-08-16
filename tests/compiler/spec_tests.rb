# coding: utf-8

$exclude_fOOrth_library = true
require_relative '../../lib/fOOrth'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class SpecTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  #Test simple parsing into words.
  def test_that_abstract_is_abstract_dammit
    assert_raises(NoMethodError) do
      AbstractWordSpec("fred", :freddy, [])
    end
  end

  def test_vm_spec
    spec = XfOOrth::VmSpec.new("fred", :freddy, [:foo])

    assert_equal("vm.freddy(vm); ", spec.builds)
    assert_instance_of(Proc, spec.does)
    assert(spec.has_tag?(:foo))
    refute(spec.has_tag?(:bar))
  end

  def test_tos_spec
    spec = XfOOrth::TosSpec.new("fred", :freddy, [:foo])

    assert_equal("vm.pop.freddy(vm); ", spec.builds)
    assert_instance_of(Proc, spec.does)
    assert(spec.has_tag?(:foo))
    refute(spec.has_tag?(:bar))
  end

  def test_nos_spec
    spec = XfOOrth::NosSpec.new("fred", :freddy, [:foo])

    assert_equal("vm.swap_pop.freddy(vm); ", spec.builds)
    assert_instance_of(Proc, spec.does)
    assert(spec.has_tag?(:foo))
    refute(spec.has_tag?(:bar))
  end

  def test_self_spec
    spec = XfOOrth::SelfSpec.new("fred", :freddy, [:foo])

    assert_equal("self.freddy(vm); ", spec.builds)
    assert_instance_of(Proc, spec.does)
    assert(spec.has_tag?(:foo))
    refute(spec.has_tag?(:bar))
  end

  def test_class_spec
    spec = XfOOrth::ClassSpec.new(Object, nil, [:class])

    assert_equal("vm.push(Object); ", spec.builds)
    assert_equal(Object, spec.new_class)
    assert_instance_of(Proc, spec.does)
    assert(spec.has_tag?(:class))
    refute(spec.has_tag?(:bar))
  end

  def test_instance_var_spec
    spec = XfOOrth::InstanceVarSpec.new("fred", :freddy, [:foo])

    assert_equal("vm.push(@freddy); ", spec.builds)
    assert_instance_of(Proc, spec.does)
    assert(spec.has_tag?(:foo))
    refute(spec.has_tag?(:bar))
  end

  def test_thread_var_spec
    spec = XfOOrth::ThreadVarSpec.new("fred", :freddy, [:foo])

    assert_equal("vm.push(vm.data[:freddy]); ", spec.builds)
    assert_instance_of(Proc, spec.does)
    assert(spec.has_tag?(:foo))
    refute(spec.has_tag?(:bar))
  end

  def test_global_var_spec
    spec = XfOOrth::GlobalVarSpec.new("fred", :freddy, [:foo])

    assert_equal("vm.push($freddy); ", spec.builds)
    assert_instance_of(Proc, spec.does)
    assert(spec.has_tag?(:foo))
    refute(spec.has_tag?(:bar))
  end

  def test_local_spec
    spec = XfOOrth::LocalSpec.new("fred", :freddy, [:foo])

    assert_equal("instance_exec(vm, &vm.context[:freddy].does); ", spec.builds)
    assert_instance_of(Proc, spec.does)
    assert(spec.has_tag?(:foo))
    refute(spec.has_tag?(:bar))
  end

  def test_macro_spec
    spec = XfOOrth::MacroSpec.new("fred", :freddy, [:foo, "macro contents"])

    assert_equal("macro contents", spec.builds)
    assert_instance_of(Proc, spec.does)
    assert(spec.has_tag?(:foo))
    refute(spec.has_tag?(:bar))
  end

end
