class CreateDrugs < ActiveRecord::Migration[5.2]
  def change
    create_table :drugs do |t|
      t.string :name
      t.string :serie
      t.string :sert_path

      t.timestamps
    end
  end
end
