# frozen_string_literal: true

require 'csv'
require_relative 'pet_products_parser.rb'
require_relative 'app.rb'
require_relative 'output_list.rb'
require_relative 'pet_product.rb'

# Recording scraped Information
class RecordToFile
  def save_as_csv_file
    CSV.open(FILENAME, 'wb') do |csv|
      rows = OutputList.new(Handler.new.fetch_links.map.each_with_index { |link, index| PetProduct.new(link, index) }).call
      rows.each { |row| csv << row }
    end
  end
end

RecordToFile.new.save_as_csv_file
