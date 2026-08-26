class CreateCompounds < ActiveRecord::Migration[8.1]
  def change
    create_table :compounds do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.string :classification
      t.string :evidence_grade
      t.text :summary
      t.date :last_reviewed_at
      t.string :confidence
      t.json :payload

      t.timestamps
    end
    add_index :compounds, :slug, unique: true
  end
end
