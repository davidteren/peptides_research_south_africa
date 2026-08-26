class CreateProviders < ActiveRecord::Migration[8.1]
  def change
    create_table :providers do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.string :kind
      t.string :status
      t.string :website
      t.string :city
      t.string :prescription_required
      t.string :listing_posture
      t.date :last_reviewed_at
      t.string :confidence
      t.json :payload

      t.timestamps
    end
    add_index :providers, :slug, unique: true
  end
end
