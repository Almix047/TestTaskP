# frozen_string_literal: true

INPUT_URL = ARGV[0].freeze
# FILENAME = ARGV[1].freeze
FILENAME = 'rezult.csv'
SITE_URL = 'https://www.petsonic.com/'
URL = 'https://www.petsonic.com/snacks-huesos-para-perros/'

# arr_product_links_per_page = page.xpath("//*[@class='nombre-producto-list prod-name-pack']//a/@href").map(&:text)

# initial link collector
class Handler
  def fetch_links
    page = PetProductsParser.new(URL).fetch_page
    arr_pages_link = page.xpath("//*[contains(@id, 'pagination_bottom')]//a/@href").map(&:text).uniq
    page.xpath("//*[@class='nombre-producto-list prod-name-pack']//a/@href").map(&:text) # arr_product_links_per_page
  end
end

# page = PetProductsParser.new(INPUT_URL).fetch_page
