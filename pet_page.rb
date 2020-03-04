# frozen_string_literal: true

require_relative 'petsonic_parser.rb'
require_relative 'pet_product.rb'

# Collecting info about page pet product
class PetPage
  attr_reader :name, :parser

  def initialize(name)
    @name = name
    @parser = PetsonicParser.new(name)
  end

  def links_on_page
    parser.fetch_page.xpath("//*[@class='nombre-producto-list prod-name-pack']//a/@href").map { |page_link| PetProduct.new(page_link.text) }
  end

  def neighboring_pages
    parser.fetch_page.xpath("//*[contains(@id, 'pagination_bottom')]//a/@href").map { |page_link| SITE_URL + page_link.text }.uniq
  end
end
