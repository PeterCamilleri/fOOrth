# coding: utf-8

#* library/formatting/hash.rb - Hash support for displaying data formatted neatly.
class Hash

  # Bullets ========================================================

  #Print out the array as bullet points.
  def puts_foorth_bullets
    puts foorth_format_bullets
  end

  #Convert the array to strings with bullet points.
  #<br>Returns
  #* A string.
  def foorth_format_bullets(page_width)
    return "" if empty?

    builder = XfOOrth::BulletPoints.new(page_width)

    self.each do |pair|
      builder.add(*pair)
    end

    builder.render.join("\n").freeze
  end

end

