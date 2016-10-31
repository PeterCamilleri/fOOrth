# coding: utf-8

#* library/formatting/bullets.rb - Print out data in neat columns.
module XfOOrth

  #A class to display data in columns.
  class ColumnizedPage
    #Prepare a blank page.
    def initialize(page_length, page_width)
      @page_length, @page_width = page_length, page_width
      @page_data = []
    end

    #Add an item to this page.
    #<br>Returns
    #* The number if items that did not fit in the page.
    def add(raw_item)
      item = raw_item.to_s
      fail "Item too large to fit." unless item.length < @page_width

      if (column = find_next_column)
        @page_data[column] << item
      else
        @page_data << [item]
      end

      adjust_configuration
    end

    #Render the page as an array of strings.
    def render
      results, column_widths = [], get_column_widths

      rows.times { |row_index| results << render_row(row_index, column_widths)}

      @page_data.clear
      results
    end

    private

    #Get the widths of all columns
    def get_column_widths
      @page_data.map {|column| column.foorth_column_width}
    end

    #Render a single row of data.
    def render_row(row_index, widths)
      @page_data.each_with_index.map do |column, index|
        column[row_index].to_s.ljust(widths[index])
      end.join(" ")
    end

    #Make sure the page fits within its boundaries.
    #<br>Returns
    #* The number if items that did not fit in the page.
    def adjust_configuration
      while total_width >= @page_width
        return @page_data.pop.length if rows == @page_length
        add_a_row
      end

      0
    end

    #Add a row to the page, moving items as needed.
    def add_a_row
      target = rows + 1
      pool, @page_data = @page_data.flatten, []

      until pool.empty?
        @page_data << pool.shift(target)
      end
    end

    #Compute the total width of all of the columns.
    #<br>Returns
    #* The sum of the widths of the widest items of each column plus a space
    #  between each of those columns.
    def total_width
      if empty?
        0
      else
        #The starting point, @page_data.length-1, represents the spaces needed
        #between the columns. So N columns means N-1 spaces.
        @page_data.inject(@page_data.length-1) do |sum, column|
          sum + column.foorth_column_width
        end
      end
    end

    #Does the data fit on the page?
    def fits?
      total_width < @page_width
    end

    #How many rows are currently in this page?
    def rows
      empty? ? 0 : @page_data[0].length
    end

    #Is this page empty?
    def empty?
      @page_data.empty?
    end

    #Which column will receive the next item?
    #<br>Returns
    #* The index of the first non-filled column or nil if none found.
    def find_next_column
      (1...(@page_data.length)).each do |index|
        if @page_data[index].length < @page_data[index-1].length
          return index
        end
      end

      nil
    end
  end

end

