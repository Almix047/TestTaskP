# frozen_string_literal: true

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
    select_products_object.each do |product|
      if product.multiple?
        data_multiple_page(product)
      else
        data_single_page(product)
      end
    end
    @rows.unshift(HEADER)
  end

  def data_multiple_page(product)
    product.price_arr.each_with_index.map do |price, index|
      row = [
        "#{name_as_on_the_site(product.name)} - #{product.weight_arr[index]}",
        price.to_f,
        product.image_link
      ]
      @rows.push(row)
    end
  end

  def data_single_page(product)
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

  # The product name on the site is changed using the CSS property 'text-transform: capitalize;'
  def name_as_on_the_site(name)
    name.split(' ').map!(&:capitalize).join(' ')
  end
end
