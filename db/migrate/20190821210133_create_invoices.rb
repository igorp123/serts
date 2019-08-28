class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.string :token
      t.string :number
      t.string :inn
      t.datetime :date
      t.timestamps
    end
  end
end
