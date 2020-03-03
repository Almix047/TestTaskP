# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'curb'
require 'csv'
require 'pry'

INPUT_URL = ARGV[0].freeze
# FILENAME = ARGV[1].freeze
FILENAME = 'rezult.csv'
SITE_URL = 'https://www.petsonic.com/'
URL = 'https://www.petsonic.com/snacks-huesos-para-perros/'

# arr_pages_link = page.xpath("//*[contains(@id, 'pagination_bottom')]//a/@href").map(&:text).uniq

# arr_product_links_per_page = page.xpath("//*[@class='nombre-producto-list prod-name-pack']//a/@href").map(&:text)

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

# Collecting info about pet product
class PetProduct
  attr_reader :product_link, :parser, :num

  def initialize(product_link, num)
    @parser = PetProductsParser.new(product_link)
    @num = num
  end

  def index_num
    puts num
    num + 1
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

# Configuration of the output view
class OutputList
  HEADER = %w[Name Price Image].freeze

  attr_reader :list_data, :products

  def initialize(products)
    @products = products
    @rows = []
  end

  def call
    @list_data = prepare_list_data
  end

  private

  def prepare_list_data
    products.each do |product|
      if product.multiple?
        handler_multiple_page(product)
      else
        handler_single_page(product)
      end
    end
    @rows.unshift(HEADER)
  end
end

def handler_multiple_page(product)
  product.price_arr.each_with_index.map do |price, index|
    row = [
      "#{product.name} - #{product.weight_arr[index]}",
      price.to_f,
      product.image_link
    ]
    @rows.push(row)
  end
end

def handler_single_page(product)
  row = [
    "#{product.name} - #{product.weight_arr.first}",
    product.price_arr.first.to_f,
    product.image_link
  ]
  @rows.push(row)
end

# initial link collector
class Handler
  def fetch_links
    page = PetProductsParser.new(URL).fetch_page
    arr_pages_link = page.xpath("//*[contains(@id, 'pagination_bottom')]//a/@href").map(&:text).uniq
    page.xpath("//*[@class='nombre-producto-list prod-name-pack']//a/@href").map(&:text) # arr_product_links_per_page
  end
end

# Recording scraped Information
class RecordToFile
  def self.save_as_csv_file
    CSV.open(FILENAME, 'wb') do |csv|
      rows = OutputList.new(Handler.new.fetch_links.map.each_with_index { |link, index| PetProduct.new(link, index) }).call
      rows.each { |row| csv << row }
    end
  end
end

# page = PetProductsParser.new(INPUT_URL).fetch_page

RecordToFile.save_as_csv_file
