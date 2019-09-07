class AddTokenToDrugs < ActiveRecord::Migration[5.2]
  def change
    add_column :drugs, :token, :string
  end
end
