# frozen_string_literal: true

# Collecting info about pet product
class PetProduct
  attr_reader :product_link, :parser

  def initialize(product_link)
    @parser = PetsonicParser.new(product_link)
  end

  def name
    parser.fetch_page.xpath("//h1[contains(@class, 'product_main_name')]").text
  end

  def weight_arr
    parser.fetch_page.xpath("#{weight_and_price_fieldset}[1]").map(&:text)
  end

  def price_arr
    parser.fetch_page.xpath("#{weight_and_price_fieldset}[last()]").map(&:text)
  end

  def image_link
    parser.fetch_page.xpath("//img[contains(@id, 'bigpic')]/@src").text
  end

  def multiple?
    weight_arr.length > 1 || price_arr.length > 1
  end

  private

  def weight_and_price_fieldset
    "//label[contains(@class, 'label_comb_price')]//span"
  end
end
