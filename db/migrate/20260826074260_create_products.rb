class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :slug, null: false
      t.string :form
      t.string :route
      t.string :strength
      t.decimal :price_zar
      t.string :title_on_page
      t.string :product_url
      t.boolean :price_visible_without_login
      t.date :last_reviewed_at
      t.string :confidence
      t.json :payload
      t.references :compound, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: true

      t.timestamps
    end
    add_index :products, :slug, unique: true
  end
end
