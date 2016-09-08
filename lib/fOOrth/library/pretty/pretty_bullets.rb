# coding: utf-8

#* library/pretty/pretty_bullets.rb - Print out bullet points.
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
    def add(raw_bullet = "*", *raw_item)

      if raw_item.empty?
        bullet = "*"
        item = raw_bullet.to_s
      else
        bullet = raw_bullet.to_s
        item = raw_item.join(' ')
      end

      @bullet_data << [bullet, item]
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
    def render_bullet(key, item)
      result = []
      input  = item.split(' ').each
      temp   = key.ljust(len = @key_length)
      pass_one = true

      loop do
        word = ' ' + input.next

        while len >= @page_width
          result << temp.slice!(0, @page_width - 1)
          temp = (' ' * @key_length) + ' ' + temp
          len  = temp.length
        end

        if ((len += word.length) >= @page_width) && !pass_one
          result << temp
          temp = (' ' * @key_length) + word
          len  = temp.length
        else
          temp << word
          pass_one = false
        end
      end

      result << temp
    end

  end

end

class Array
  #Print out the array as bullet points.
  def puts_foorth_bullets(page_width = 80)
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

class Hash
  #Print out the hash as bullet points.
  def puts_foorth_bullets(page_width = 80)
    puts foorth_bulletize(page_width)
  end

  #Convert the hash to strings with bullet points.
  #<br>
  #* An array of arrays of strings
  def foorth_bulletize(page_width)
    builder = XfOOrth::BulletPoints.new(page_width)

    self.each do |key, value|
      builder.add(key, value)
    end

    builder.render
  end
end
