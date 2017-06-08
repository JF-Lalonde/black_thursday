require_relative 'test_helper'
require_relative '../lib/customer'
require_relative '../lib/sales_engine'

class CustomerTest < Minitest::Test
  def setup
      @se = SalesEngine.from_csv({
            :items => "./test/data/items_truncated.csv",
            :merchants => "./test/data/merchants_truncated.csv",
            :invoice_items => "./test/data/invoice_items_truncated.csv",
            :invoices => "./test/data/invoices_truncated.csv",
            :transactions => "./test/data/transactions_truncated.csv",
            :customers => "./test/data/customers_truncated.csv"
          })
      @c = Customer.new({
        :id => 6,
        :first_name => "Joan",
        :last_name => "Clarke",
        :created_at => Time.now,
        :updated_at => Time.now
      }, self)
  end

  def test_customer_id_can_be_read
    assert_equal 6, @c.id
  end

  def test_first_name_can_be_read
    assert_equal "Joan", @c.first_name
  end

  def test_created_at_returns_time
    assert_equal Time, @c.created_at.class
  end

  def test_merchants_method_returns_merchant_class
    customer = @se.customers.find_by_id(1)
    actual = customer.merchants[0].class

    assert_equal Merchant, actual
  end
end
