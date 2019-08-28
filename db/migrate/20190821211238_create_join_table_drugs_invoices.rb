class CreateJoinTableDrugsInvoices < ActiveRecord::Migration[5.2]
  def change
    create_join_table :drugs, :invoices do |t|
      t.index [:invoice_id, :drug_id]
    end
  end
end
