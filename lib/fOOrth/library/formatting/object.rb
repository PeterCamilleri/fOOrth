# coding: utf-8

#* library/formatting/object.rb - Support for displaying data formatted neatly.
class Object

  #Create a bullet point description from this object.
  def format_description(max_width)
    self.to_s.format_description(max_width)
  end

  #Get data ready for being in a bullet point.
  def prepare_bullet_data
    ["*", self]
  end

end


