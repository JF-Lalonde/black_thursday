require 'csv'
require_relative '../lib/merchant'
require_relative '../lib/file_opener'

class MerchantRepository
  include FileOpener
  attr_reader :all_merchant_data,
              :sales_engine

  def inspect
    "#<#{self.class} #{@all_merchant_data.size} rows>"
  end

  def initialize(data_files, sales_engine)
    @sales_engine = sales_engine
    all_merchants = open_csv(data_files[:merchants])
    @all_merchant_data = all_merchants.map{|row| Merchant.new(row, self)}
  end

  def all
    all_merchant_data
  end

  def find_by_id(id)
    all_merchant_data.find{|merchant| merchant.id == id}
  end

  def find_by_name(name)
    all_merchant_data.find{|merchant| merchant.name.downcase == name.downcase}
  end

  def find_all_by_name(name)
    all_merchant_data.find_all{|merchant| (/#{name}/i) =~ merchant.name}
  end

  def item_from_merch(merch_id)
    sales_engine.item_from_merch(merch_id)
  end

  def invoices_from_merch(id)
    sales_engine.invoices_from_merch(id)
  end

  def customers_from_merchant(id)
    sales_engine.customers_from_merchant(id)
  end
end
