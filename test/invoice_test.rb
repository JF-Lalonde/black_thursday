require_relative 'test_helper'
require_relative '../lib/invoice'

class InvoiceTest < Minitest::Test

  attr_reader :invoice

  def setup
    @invoice = Invoice.new({
      :id          => 6,
      :customer_id => 7,
      :merchant_id => 8,
      :status      => "pending",
      :created_at  => Time.now,
      :updated_at  => Time.now,
      }, self)
  end

  def test_it_exists
    assert_instance_of Invoice, @invoice
  end

  def test_attr_reader_works
    assert_equal 8, @invoice.merchant_id
  end
end
