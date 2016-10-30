# coding: utf-8

require_relative './support/foorth_testing'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the standard fOOrth library.
class StdioLibraryTester < Minitest::Test

  include XfOOrthTestExtensions

  #Track mini-test progress.
  include MinitestVisible

  def test_the_dot
    foorth_output('4 .', "4")
    foorth_output('-4 .', "-4")
    foorth_output('"test" .', "test")
    foorth_output('Object .name .', "Object")
  end

  def test_the_dot_quote
    foorth_output('."test"', "test")
  end

  def test_the_dot_cr
    foorth_output('cr', "\n")
  end

  def test_the_space
    foorth_output('space', " ")
  end

  def test_the_spaces
    foorth_output('1 spaces', " ")
    foorth_output('2 spaces', "  ")
    foorth_output('0 spaces', "")
    foorth_raises('"apple"  spaces')
  end

  def test_the_emit
    foorth_output(' 65 .emit', "A")
    foorth_output('126 .emit', "~")

    foorth_utf8_output('255 .emit', [195, 191])

    foorth_output(' "A123" .emit', "A")
    foorth_raises('1+1i .emit')
  end

  #Looks like some unit testing has crept into integration testing. OK.
  def test_some_formatting
    assert_equal("1 4\n2 5\n3  ",       [1,2,3,4,5].format_foorth_columns(false, 5))
    assert_equal(["1 4", "2 5", "3  "], [1,2,3,4,5].format_description(5))

    assert_equal(["1 2", "3 4", "5"],   "1 2 3 4 5".format_description(5))

    assert_equal([], [].format_description(5))
    assert_equal([], nil.format_description(5))

    result =
       "1 5 9  13 17 21 25 29 33 37 41 45 49 53 57 61 65 69 73 77 81 85 89 93 97 \n" +
       "2 6 10 14 18 22 26 30 34 38 42 46 50 54 58 62 66 70 74 78 82 86 90 94 98 \n" +
       "3 7 11 15 19 23 27 31 35 39 43 47 51 55 59 63 67 71 75 79 83 87 91 95 99 \n" +
       "4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100"

    assert_equal(result, (1..100).to_a.format_foorth_columns(false, 80) )

    data =
      [["key_largo", "/long_folder_name_one/long_folder_name_two/long_folder_name_three/fine_descriptive_name"],
       ["key_west",  "Semper ubi sub ubi. Semper ubi sub ubi. Semper ubi sub ubi. Semper ubi sub ubi. "],
       ["counting",  Array.new(100) {|i| i} ],
       ["pie", Math::PI]
      ]

    result =
       "key_largo /long_folder_name_one/long_folder_name_two/long_folder_name_three/fin\n" +
       "          e_descriptive_name\n" +
       "key_west  Semper ubi sub ubi. Semper ubi sub ubi. Semper ubi sub ubi. Semper\n" +
       "          ubi sub ubi.\n" +
       "counting  0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95\n" +
       "          1 6 11 16 21 26 31 36 41 46 51 56 61 66 71 76 81 86 91 96\n" +
       "          2 7 12 17 22 27 32 37 42 47 52 57 62 67 72 77 82 87 92 97\n" +
       "          3 8 13 18 23 28 33 38 43 48 53 58 63 68 73 78 83 88 93 98\n" +
       "          4 9 14 19 24 29 34 39 44 49 54 59 64 69 74 79 84 89 94 99\n" +
       "pie       3.141592653589793"

    assert_equal(result, data.foorth_format_bullets(80))

    assert_equal("", [].foorth_format_bullets(80))


    data =
      {"key_largo" => "/long_folder_name_one/long_folder_name_two/long_folder_name_three/fine_descriptive_name",
       "key_west"  => "Semper ubi sub ubi. Semper ubi sub ubi. Semper ubi sub ubi. Semper ubi sub ubi. ",
       "counting"  => Array.new(100) {|i| i},
       "pie"       => Math::PI
      }

    assert_equal(result, data.foorth_format_bullets(80))

  end

end
