# coding: utf-8

#* library/formatting/bullets.rb - Print out bullet points.
module XfOOrth

  #A class to display data in bullet points.
  class BulletPoints
    #Prepare a blank slate.
    def initialize(page_width)
      @page_width, @bullet_data = page_width, []
    end

    #Add an item to this page.
    #<br>Returns
    #* The number if items that did not fit in the page.
    #<br>Endemic Code Smells
    #* :reek:FeatureEnvy
    def add(raw_bullet = "*", *raw_item)

      if raw_item.empty?
        bullet = ["*"]
        items = raw_bullet.in_array
      else
        bullet = [raw_bullet]
        items = raw_item.in_array
      end

      items.each_index do |index|
        @bullet_data << [(bullet[index] || "").to_s, items[index].to_s]
      end
    end

    #Render the page as an array of strings.
    def render
      @key_length, results = get_key_length, []

      @bullet_data.each do |key, item|
        results.concat(render_bullet(key, item))
      end

      @bullet_data = []
      results
    end

    private

    #How large is the largest bullet?
    def get_key_length
      (@bullet_data.max_by {|line| line[0].length})[0].length
    end

    #Render one bullet point.
    #<br>Endemic Code Smells
    #* :reek:DuplicateMethodCall :reek:TooManyStatements
    def render_bullet(key, item)
      result, pass_one = [], true
      input  = item.split(' ').each
      temp   = key.ljust(len = @key_length)

      loop do
        word = ' ' + input.next

        while len >= @page_width
          result << temp.slice!(0, @page_width - 1)
          temp = blank_key + ' ' + temp
          len  = temp.length
        end

        if ((len += word.length) >= @page_width) && !pass_one
          result << temp
          temp = blank_key + word
          len  = temp.length
        else
          temp << word
          pass_one = false
        end
      end

      result << temp
    end

    #Generate a blank bullet key
    def blank_key
      ' ' * @key_length
    end

  end

end

#Bullet point support in the Array class.
class Array
  #Print out the array as bullet points.
  def puts_foorth_bullets(page_width)
    puts foorth_bulletize(page_width)
  end

  #Convert the array to strings with bullet points.
  #<br>
  #* An array of arrays of strings
  def foorth_bulletize(page_width)
    builder = XfOOrth::BulletPoints.new(page_width)

    self.each do |pair|
      builder.add(*pair)
    end

    builder.render
  end
end

#Bullet point support in the Hash class.
class Hash
  #Print out the hash as bullet points.
  def puts_foorth_bullets(page_width)
    puts foorth_bulletize(page_width)
  end

  #Convert the hash to strings with bullet points.
  #<br>
  #* An array of arrays of strings
  def foorth_bulletize(page_width)
    builder = XfOOrth::BulletPoints.new(page_width)

    self.each do |key, value|
      builder.add(key, *value.in_array)
    end

    builder.render
  end
end
