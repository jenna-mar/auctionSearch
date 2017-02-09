class CreateListings < ActiveRecord::Migration[5.0]
  def change
    create_table :listings do |t|
      t.string :title
      t.string :url
      t.string :img
      t.references :search, foreign_key: true

      t.timestamps
    end
  end
end
