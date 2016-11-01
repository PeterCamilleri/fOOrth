# coding: utf-8

#* library/formatting/string.rb - Support for displaying data formatted neatly.
class String

  #Create a bullet point description from this string.
  def format_description(max_width)
    do_format_description(split(' ').each, max_width)
  end

  #Do the formatting legwork.
  def do_format_description(input, max_width)
    result, build = [], ""

    loop do
      build = build.split_if_over(input.next, max_width, result)
                   .split_if_huge(max_width, result)
    end

    result << build
  end

  #Split if adding a word goes over a little.
  def split_if_over(word, max_width, buffer)
    word.prepend(" ") unless self.empty?
    word_len = word.length

    if (length + word_len) >= max_width && word_len < max_width
      buffer << self
      word.lstrip
    else
      self + word
    end

  end

  #Split up a overlong blob of text.
  def split_if_huge(max_width, buffer)
    while length >= max_width
      buffer << slice!(0, max_width)
    end

    self
  end
end

