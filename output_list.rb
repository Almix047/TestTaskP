# frozen_string_literal: true

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
