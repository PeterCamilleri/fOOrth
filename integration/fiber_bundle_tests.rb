# coding: utf-8

require_relative '../lib/fOOrth'
require_relative 'support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class FiberBundleLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  include MinitestVisible

  def test_that_the_fiber_classes_exist
    foorth_equal('Fiber',  [XfOOrth::XfOOrth_Fiber])
    foorth_equal('Bundle', [XfOOrth::XfOOrth_Bundle])
  end

  # Fiber tests!

  def test_creating_a_fiber
    test_code = <<-EOS
      Fiber .new{{  }} .class .name
    EOS

    foorth_equal(test_code, ["Fiber"])
  end

  def test_fiber_processing
    test_code = <<-EOS
      // Create a fibonacci fiber.
      Fiber .new{{ 1 1 11 do i * yield loop .yield }} val$: $fac

      0 10 do $fac .step loop $fac .step
    EOS

    foorth_equal(test_code, [3628800])
  end

  def test_fiber_processing_data
    test_code = <<-EOS
      // Create a fibonacci fiber.
      Fiber .new{{ 1 1 begin dup .yield over + swap again }} val$: $fib

      0 8 do $fib .step loop
    EOS

    foorth_equal(test_code, [1, 1, 2, 3, 5, 8, 13, 21])
  end

  def test_fiber_processing_overrun
    test_code = <<-EOS
      // Create a fiber fiber.
      Fiber .new{{ 0 5 do i .yield loop }} val$: $ovr

      0 8 do $ovr .step loop
    EOS

    foorth_raises(test_code)
  end

  def test_for_fiber_alive
    foorth_run('Fiber .new{{ yield }} val$: $alive')
    foorth_equal('$alive .alive?', [true])
    foorth_equal('$alive .step $alive .alive?', [true])
    foorth_equal('$alive .step $alive .alive?', [false])
    foorth_raises('$alive .step')
  end

  def test_for_bad_yield
    foorth_raises('5 .yield')
  end

  def test_making_a_fiber_from_a_procedure
    test_code = <<-EOS
      // Create a fibonacci fiber.
      {{ 1 1 begin dup .yield over + swap again }} .to_fiber val$: $fib

      0 8 do $fib .step loop
    EOS

    foorth_equal(test_code, [1, 1, 2, 3, 5, 8, 13, 21])
  end

  def test_making_a_fiber_from_not_a_procedure
    foorth_raises('42 .to_fiber')
  end

  def test_getting_the_current_fiber
    foorth_run('Fiber .new{{ Fiber .current .yield }} val$: $current')

    foorth_equal('Fiber .current', [nil])

    symbol = XfOOrth::SymbolMap.map('$current')
    current = eval "#{'$' + symbol.to_s}"

    foorth_equal('$current .step', [current])
  end

  def test_converting_a_fiber_to_a_fiber
    foorth_run('Fiber .new{{  }} val$: $current')

    symbol = XfOOrth::SymbolMap.map('$current')
    current = eval "#{'$' + symbol.to_s}"

    foorth_equal('$current .to_fiber', [current])
  end

  #Bundle tests!

  def test_making_a_bundle_of_fibers
    test_code = <<-EOS
      // Create a bunch of fibers.
      [ {{ 1 .yield }} {{ 2 .yield }} {{ 3 .yield }} ] .to_bundle val$: $bundle

      $bundle .run
    EOS

    foorth_equal(test_code, [1, 2, 3])
  end

  def test_making_a_bundle_of_one_fiber
    test_code = <<-EOS
      // Create a bunch of one fiber.
      {{ 1 .yield }} .to_bundle val$: $bundle

      $bundle .run
    EOS

    foorth_equal(test_code, [1])
  end

  def test_making_a_bundle_of_nested_fibers
    test_code = <<-EOS
      // Create a bunch of fibers.
      [ {{ 2 .yield }} {{ 4 .yield }} {{ 5 .yield }} ] .to_bundle val$: $sub

      [ {{ 1 .yield }} $sub {{ 3 .yield }} ] .to_bundle val$: $bundle

      $bundle .run
    EOS

    foorth_equal(test_code, [1, 2, 3, 4, 5])
  end

  def test_a_bundle_one_step_at_time
    test_code = <<-EOS
      // Create a bunch of fibers.
      [ {{ 2 .yield }} {{ 4 .yield }} {{ 5 .yield }} ] .to_bundle val$: $sub

      [ {{ 1 .yield }} $sub {{ 3 .yield }} ] .to_bundle val$: $bundle
    EOS

    foorth_run(test_code)
    foorth_equal('$bundle .alive?', [true])
    foorth_equal('$bundle .length', [3])

    foorth_equal('$bundle .step', [1])
    foorth_equal('$bundle .alive?', [true])

    foorth_equal('$bundle .step', [2])
    foorth_equal('$bundle .alive?', [true])

    foorth_equal('$bundle .step', [3])
    foorth_equal('$bundle .alive?', [true])

    foorth_equal('$bundle .step', [4])
    foorth_equal('$bundle .alive?', [true])

    foorth_equal('$bundle .step', [5])
    foorth_equal('$bundle .alive?', [false])

    foorth_equal('$bundle .step', [])
    foorth_equal('$bundle .alive?', [false])

    foorth_equal('$bundle .step', [])
    foorth_equal('$bundle .alive?', [false])
  end

  def test_converting_a_bundle_to_a_fiber
    foorth_run('[ {{  }} {{ }} ] .to_bundle val$: $test')

    symbol = XfOOrth::SymbolMap.map('$test')
    test = eval "#{'$' + symbol.to_s}"

    foorth_equal('$test .to_fiber', [test])
  end

  def test_adding_fibers_to_a_bundle
    foorth_run('Bundle .new val$: $add')
    foorth_equal('{{ }} $add .add $add .length', [1])
    foorth_equal('{{ }} $add .add $add .length', [2])
    foorth_equal('{{ }} $add .add $add .length', [3])
    foorth_equal('{{ }} $add .add $add .length', [4])

    foorth_raises('42 $add .add $add .length')
  end

  def test_making_a_bundle_of_not_fibers
    foorth_raises('[ 1 2 3 ] .to_bundle')
  end

end
