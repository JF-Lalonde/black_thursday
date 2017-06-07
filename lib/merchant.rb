require_relative '../lib/merchant_repository'

class Merchant
  attr_reader :id,
              :name,
              :merch_repo

  def initialize(merchant_data, merch_repo)
  @id = merchant_data[:id].to_i
  @name = merchant_data[:name]
  @merch_repo = merch_repo
  end

  def items
    @merch_repo.item_output(id)
  end

  def invoices
    @merch_repo.invoice_output(id)
  end

  def customers
    @merch_repo.customers_from_merchant(id)
  end
end
