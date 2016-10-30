# coding: utf-8

#* library/formatting/array.rb - Array support for displaying data formatted neatly.
class Array

  # Columns ========================================================

  #Print out the array with efficient columns.
  def puts_foorth_columns(page_length, page_width)
    format_foorth_columns(page_length, page_width).each do |page|
      puts page, ""
    end
  end

  #Convert the array to strings with efficient columns.
  #<br>
  #* An array of arrays of strings
  def format_foorth_columns(page_length, page_width)
    index, pages, limit = 0, [], self.length
    builder = XfOOrth::ColumnizedPage.new(page_length, page_width)

    while index < limit
      index += 1 - (left_over = builder.add(self[index]))
      pages << builder.render if (left_over > 0) || (index == limit)
    end

    pages
  end

  #Convert the array to a bullet point description.
  #<br>
  #* An array of strings.
  def format_description(page_width)
    format_foorth_columns(false, page_width)[0]
  end

  #Get the widest element of an array.
  #<br>Returns
  #* The width of the widest string in the array.
  def foorth_column_width
    (self.max_by {|item| item.length}).length
  end


  # Bullets ========================================================

  #Print out the array as bullet points.
  def puts_foorth_bullets
    puts foorth_bulletize
  end

  #Convert the array to strings with bullet points.
  #<br>
  #* An array of strings
  def foorth_bulletize(page_width)
    return "" if empty?

    builder = Mysh::BulletPoints.new(page_width)

    self.each do |pair|
      builder.add(*pair)
    end

    builder.render
  end

end

