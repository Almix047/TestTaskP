# frozen_string_literal: true

require 'nokogiri'
require 'curb'

# Scraping information about pet products from site category
class PetProductsParser
  attr_reader :link

  def initialize(link)
    @link = link
  end

  def fetch_page
    @fetch_page ||= pet_product_parse(link)
  end

  private

  def pet_product_parse(link)
    Nokogiri::HTML(Curl.get(link).body_str)
  end
end
