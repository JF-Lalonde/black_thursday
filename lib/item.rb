require_relative '../lib/item_repository'
require 'bigdecimal'
require 'bigdecimal/util'
require 'time'


class Item
  attr_reader :id,
              :name,
              :description,
              :created_at,
              :updated_at,
              :merchant_id,
              :unit_price_to_dollars,
              :item_repo

  attr_accessor :unit_price

  def initialize(item_data, item_repo)
  @item_repo = item_repo
  @id = item_data[:id].to_i
  @name = item_data[:name]
  @description = item_data[:description]
  @unit_price = unit_price_to_dollars(item_data[:unit_price].to_d)
  @created_at = Time.parse(item_data[:created_at].to_s)
  @updated_at = Time.parse(item_data[:updated_at].to_s)
  @merchant_id = item_data[:merchant_id].to_i
  end

  def unit_price_to_dollars(price)
    price / 100
  end

  def merchant
    @item_repo.merchant(merchant_id)
  end
end
