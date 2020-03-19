# frozen_string_literal: true

require_relative 'informer.rb'

# Configuration of the output view
class OutputList
  HEADER = %w[Name Price Image].freeze

  attr_reader :list_data, :pages

  def initialize(pages)
    @pages = pages
    @rows = []
  end

  def call
    prepare_list_data
  end

  private

  def prepare_list_data
    products = select_products_object
    products_all_num = products.length
    Informer.result_reading_message(products_all_num, pages.length)
    products.each_with_index do |product, index|
      Informer.processing_message(index, products_all_num, product.product_link)
      product.multiple? ? multiple_page(product) : single_page(product)
    end
    @rows.unshift(HEADER)
  end

  def multiple_page(product)
    product.price_arr.each_with_index.map do |price, index|
      row = [
        "#{name_as_on_the_site(product.name)} - #{product.weight_arr[index]}",
        price.to_f,
        product.image_link
      ]
      @rows.push(row)
    end
  end

  def single_page(product)
    row = [
      "#{name_as_on_the_site(product.name)} - #{product.weight_arr.first}",
      product.price_arr.first.to_f,
      product.image_link
    ]
    @rows.push(row)
  end

  def select_products_object
    pages.map(&:links_on_page).flatten
  end

  # The product name on the site is changed
  # using the CSS property 'text-transform: capitalize;'
  def name_as_on_the_site(name)
    name.split(' ').map!(&:capitalize).join(' ')
  end
end
