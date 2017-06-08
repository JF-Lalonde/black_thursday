require 'csv'
require_relative '../lib/invoice'
require_relative '../lib/file_opener'

class InvoiceRepository
  include FileOpener

  attr_reader :sales_engine,
              :all_invoice_data

  def inspect
    "#<#{self.class} #{@all_invoice_data.size} rows>"
  end

  def initialize(data_files, sales_engine)
    @sales_engine = sales_engine
    all_invoices = open_csv(data_files[:invoices])
    @all_invoice_data = all_invoices.map{|row| Invoice.new(row, self)}
  end

  def all
    @all_invoice_data
  end

  def find_by_id(id)
    @all_invoice_data.find{|invoice| invoice.id == id}
  end

  def find_all_by_customer_id(customer_id)
    @all_invoice_data.find_all{|invoice| invoice.customer_id == customer_id}
  end

  def find_all_by_merchant_id(merchant_id)
    @all_invoice_data.find_all{|invoice| invoice.merchant_id == merchant_id}
  end

  def find_all_by_status(status)
    @all_invoice_data.find_all{|invoice| invoice.status == status}
  end

  def items_from_invoice(id)
    @sales_engine.items_from_invoice(id)
  end

  def invoice_middle_output(id)
    @sales_engine.invoice_output(id)
  end

  def transactions_from_invoice(id)
    @sales_engine.transactions_from_invoice(id)
  end

  def customer_from_invoice(id)
    @sales_engine.customer_from_invoice(id)
  end

  def total_from_invoice(id)
    @sales_engine.total_from_invoice(id)
  end
end
