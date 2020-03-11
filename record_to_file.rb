# frozen_string_literal: true

require 'csv'
require_relative 'output_list.rb'

# Recording scraped Information
class RecordToFile
  def self.save_as_csv_file
    current_page = PetPage.new(INPUT_URL)
    pages_links = current_page.neighboring_pages
    pages = pages_links.map { |page| PetPage.new(page) }.unshift(current_page)
    rows = OutputList.new(pages).call
    # Return if no items to parse are found.
    # 1 because the first row is the HEADER.
    return if rows.length == 1

    Informer.write_data_message
    CSV.open(FILENAME, 'wb') do |csv|
      rows.each { |row| csv << row }
    end
  end
end
