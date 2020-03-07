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
    path = "//*[@class='nombre-producto-list prod-name-pack']//a/@href"
    parser.fetch_page.xpath(path).map { |link| PetProduct.new(link.text) }
  end

  def neighboring_pages
    path = "//*[contains(@id, 'pagination_bottom')]//a/@href"
    parser.fetch_page.xpath(path).map { |link| SITE_URL + link.text }.uniq
  end
end
