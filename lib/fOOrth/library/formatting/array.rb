# coding: utf-8

#* library/formatting/array.rb - Array support for displaying data formatted neatly.
class Array

  # Columns ========================================================

  #Print out the array with efficient columns.
  def puts_foorth_columns(page_length, page_width)
    format_foorth_pages(page_length, page_width).each do |page|
      puts page, ""
    end
  end

  #Convert the array to strings with efficient columns.
  #<br>Returns
  #* A string.
  def format_foorth_columns(page_length, page_width)
    format_foorth_pages(page_length, page_width)
      .map {|page| page << ""}
      .flatten[0...-1]
      .join("\n")
      .freeze
  end

  #Get the widest element of an array.
  #<br>Returns
  #* The width of the widest string in the array.
  def foorth_column_width
    (self.max_by {|item| item.length}).length
  end

  private

  #Convert the array to strings with efficient columns.
  #<br>Returns
  #* An array of pages (arrays of strings)
  def format_foorth_pages(page_length, page_width)
    index, pages, limit = 0, [], self.length
    builder = XfOOrth::ColumnizedPage.new(page_length, page_width)

    while index < limit
      index += 1 - (left_over = builder.add(self[index]))
      pages << builder.render if (left_over > 0) || (index == limit)
    end

    pages
  end

  # Bullets ========================================================

  public

  #Print out the array as bullet points.
  def puts_foorth_bullets(page_width)
    puts foorth_format_bullets(page_width)
  end

  #Convert the array to strings with bullet points.
  #<br>Returns
  #* A string
  def foorth_format_bullets(page_width)
    return "" if empty?

    builder = XfOOrth::BulletPoints.new(page_width)

    self.each do |pair|
      builder.add(*pair.prepare_bullet_data)
    end

    builder.render.join("\n").freeze
  end

  #Convert the array to a bullet point description.
  #<br>Returns
  #* An array of strings.
  def format_description(page_width)
    format_foorth_pages(false, page_width)[0] || []
  end

  #Get data ready for being in a bullet point.
  def prepare_bullet_data
    if length < 2
      ["*", self[0]]
    else
      self
    end
  end

end
