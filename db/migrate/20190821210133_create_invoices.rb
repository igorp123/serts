class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.string :number
      t.string :inn

      t.timestamps
    end
  end
end
