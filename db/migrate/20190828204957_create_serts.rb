class CreateSerts < ActiveRecord::Migration[5.2]
  def change
    create_table :serts do |t|
      t.string :sert
      t.references :drug, foreign_key: true

      t.timestamps
    end
  end
end
