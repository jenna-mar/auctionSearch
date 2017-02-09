class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches do |t|
      t.string :name
      t.string :category
      t.string :site

      t.timestamps
    end
  end
end
