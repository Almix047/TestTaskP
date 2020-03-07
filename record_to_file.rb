# frozen_string_literal: true

require 'csv'
require_relative 'output_list.rb'

# Recording scraped Information
class RecordToFile
  def self.save_as_csv_file
    page_links_arr = PetPage.new(INPUT_URL).neighboring_pages.unshift(INPUT_URL)
    rows = OutputList.new(page_links_arr.map { |category_page| PetPage.new(category_page) }).call
    return if rows.length == 1 # Return if no items to parse are found. 1 because the first row is the HEADER.

    Informer.write_data_message
    CSV.open(FILENAME, 'wb') do |csv|
      rows.each { |row| csv << row }
    end
  end
end
