class AddCounterToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :counter, :integer
  end
end
