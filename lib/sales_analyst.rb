require_relative '../lib/sales_engine'

class SalesAnalyst

  attr_reader :sales_engine,
              :avg_items,
              :avg_prices_per_merch,
              :all_item_prices,
              :invoices_per_merch,
              :day_count

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def average_items_per_merchant
    @avg_items =
    sales_engine.merchants.all_merchant_data.map{|merch| merch.items.count}
    (avg_items.reduce{|sum, num| sum + num}.to_f / avg_items.count).round(2)
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    sum = avg_items.reduce(0){|sum, num| sum + (num - mean)**2}
    Math.sqrt(sum / (avg_items.count - 1)).round(2)
  end

  def merchants_with_high_item_count
    mean = average_items_per_merchant
    std_dev = average_items_per_merchant_standard_deviation
    sales_engine.merchants.all_merchant_data.find_all{|merchant|
      merchant.items.count > (mean + std_dev)}
  end

  def average_item_price_for_merchant(merchant_id)
    merch_items = sales_engine.item_from_merch(merchant_id)
    item_prices = []
      merch_items.find_all{|item| item_prices << item.unit_price}
      if item_prices.count > 0
        (item_prices.reduce(:+) / (item_prices.count)).round(2)
      end
  end

  def find_all_merchant_ids
    merchants = sales_engine.merchants.all
    merch_ids = merchants.map{|merchant| merchant.id.to_i}
  end

  def average_average_price_per_merchant
    @avg_prices_per_merch = Array.new
    find_all_merchant_ids.each{|merchant_id|
      if average_item_price_for_merchant(merchant_id) != nil
        avg_prices_per_merch << average_item_price_for_merchant(merchant_id)
      end}
      (avg_prices_per_merch.reduce(:+) / avg_prices_per_merch.count).round(2)
  end

  def average_item_price_overall
    all_items = sales_engine.items.all
    @all_item_prices = all_items.map{|item| item.unit_price}
    all_item_prices.reduce{|sum, num| sum + num}.to_f/ all_item_prices.count
  end

  def standard_deviation_of_prices
    mean = average_item_price_overall
    sum = all_item_prices.reduce(0){|sum, num| sum + (num - mean)**2}
    std_dev = Math.sqrt(sum / (all_item_prices.count - 1)).round(2)
  end

  def golden_items
    mean = average_item_price_overall
    std_dev = standard_deviation_of_prices
    sales_engine.items.all_item_data.find_all do |item|
      (item.unit_price - mean) > (std_dev * 2)
    end
  end

  def average_invoices_per_merchant
    @invoices_per_merch =
    sales_engine.merchants.all_merchant_data.map{|merchant|
      merchant.invoices.count}
    (invoices_per_merch.reduce{|sum, num| sum + num}.to_f /
    invoices_per_merch.count).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    mean = average_invoices_per_merchant
    sum = invoices_per_merch.reduce(0){|sum, num| sum + (num - mean)**2}
    Math.sqrt(sum / (invoices_per_merch.count - 1)).round(2)
  end

  def top_merchants_by_invoice_count
    std_devs = (average_invoices_per_merchant_standard_deviation * 2)
    mean = average_invoices_per_merchant
    sales_engine.merchants.all_merchant_data.find_all{|merchant|
      (merchant.invoices.count - mean) > std_devs}
  end

  def bottom_merchants_by_invoice_count
    std_devs = (average_invoices_per_merchant_standard_deviation*2)
    mean = average_invoices_per_merchant
    sales_engine.merchants.all_merchant_data.find_all{|merchant|
      (mean - merchant.invoices.count) > std_devs}
  end

  def average_sales_per_day
    invoice_dates = sales_engine.invoices.all_invoice_data.map{|invoice|
      invoice.created_at.strftime("%A")}
    @day_count =
    invoice_dates.reduce(Hash.new(0)){|days, num| days[num] += 1; days}
    day_count.values.reduce(:+)/ 7
  end

  def average_sales_per_day_standard_deviation
    mean = average_sales_per_day
    sum = day_count.values.reduce(0){|sum, num| sum + (num - mean)**2}
    Math.sqrt(sum / 6).round(2)
  end

  def top_days_by_invoice_count
    mean = average_sales_per_day
    days = day_count.find_all{|day, num|
      (num - mean) > average_sales_per_day_standard_deviation}.flatten
    days.select.with_index{|item, index| index.even?}
  end

  def calculate_invoice_percentages
    status = sales_engine.invoices.all.map{|invoice| invoice.status}
    status = status.reduce(Hash.new(0)){|status, num| status[num] += 1; status}
    sum = status.values.inject(:+)
    status.each_with_object(Hash.new(0)){|(stat, num), hash|
      hash[stat] = num * 100.0 / sum}
  end

  def invoice_status(status)
    calculate_invoice_percentages[status].round(2)
  end
end
