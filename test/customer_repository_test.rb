require_relative 'test_helper'
require_relative '../lib/customer_repository'
require_relative '../lib/sales_engine'

class CustomerRepositoryTest < Minitest::Test

  def setup
  @se = SalesEngine.from_csv({
        :items => "./test/data/items_truncated.csv",
        :merchants => "./test/data/merchants_truncated.csv",
        :invoice_items => "./test/data/invoice_items_truncated.csv",
        :invoices => "./test/data/invoices_truncated.csv",
        :transactions => "./test/data/transactions_truncated.csv",
        :customers => "./test/data/customers_truncated.csv"
      })
    @cr = CustomerRepository.new({customers: "./test/data/customers_truncated.csv"}, self)
  end

  def test_customer_repo_instantiates
    assert_equal CustomerRepository, @cr.class
  end

  def test_customer_repo_opens_csv_into_array
    assert_equal Array, @cr.all_customer_data.class
  end

  def test_it_returns_customer_instance
    assert_equal Customer, @cr.all[2].class
  end

  def test_it_can_find_by_id
    actual = @cr.find_by_id(6)
    expected = @cr.all[5]

    assert_equal expected, actual
  end

  def test_it_can_return_matches_from_partial_first_names
    actual = @cr.find_all_by_first_name("joe")
    expected = [@cr.all[0]]

    assert_equal expected, actual
  end

  def test_it_can_return_matches_from_partial_last_names
    actual = @cr.find_all_by_last_name("pe")
    expected = [@cr.all[14], @cr.all[15], @cr.all[31]]

    assert_equal expected, actual
  end

  def test_merchants_from_customer_returns_merchants
    customer = @se.customers.find_by_id(1)
    actual = customer.merchants[0].class

    assert_equal Merchant, actual
  end
end
