require 'csv'
require_relative '../lib/merchant_repository'
require_relative '../lib/item_repository'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/transaction_repository'
require_relative '../lib/customer_repository'
require_relative '../lib/invoice_repository'

class SalesEngine
  attr_reader :items,
              :merchants,
              :invoice_items,
              :transactions,
              :customers,
              :invoices

  def initialize(data_files)
    @items = ItemRepository.new(data_files, self)
    @merchants = MerchantRepository.new(data_files, self)
    @invoice_items = InvoiceItemRepository.new(data_files, self)
    @transactions = TransactionRepository.new(data_files, self)
    @customers = CustomerRepository.new(data_files, self)
    @invoices = InvoiceRepository.new(data_files, self)
  end

  def self.from_csv(data_files)
    SalesEngine.new(data_files)
  end

  def merchant_output(merchant_id)
    @merchants.find_by_id(merchant_id)
  end

  def item_output(merch_id)
    @items.find_all_by_merchant_id(merch_id)
  end

  def invoice_output(id)
    @merchants.find_by_id(id)
  end

  def merch_out_from_invoice(id)
    @invoices.find_all_by_merchant_id(id)
  end

  def items_from_invoice(id)
    invoice_items = @invoice_items.find_all_by_invoice_id(id)
    item_ids = invoice_items.map{|item| item.item_id}
    item_ids.map{|item| @items.find_by_id(item)}.compact
  end

  def transactions_from_invoice(id)
    @transactions.find_all_by_invoice_id(id)
  end

  def customer_from_invoice(id)
    @customers.find_by_id(id)
  end

  def invoice_from_transaction(invoice_id)
    @invoices.find_by_id(invoice_id)
  end

  def customers_from_merchant(id)
    invoices = @invoices.find_all_by_merchant_id(id)
    customer_ids = invoices.map{|invoice| invoice.customer_id}
    customer_ids.map{|id| @customers.find_by_id(id)}.compact
  end

  def merchants_from_customer(id)
    invoices = @invoices.find_all_by_customer_id(id)
    merch_ids = invoices.map{|invoice| invoice.merchant_id}
    merch_ids.map{|id| @merchants.find_by_id(id)}.compact
  end
end
