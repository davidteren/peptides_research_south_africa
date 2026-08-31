class CreateStacks < ActiveRecord::Migration[8.1]
  def change
    create_table :stacks do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.string :origin
      t.string :confidence
      t.date :last_reviewed_at
      t.json :payload

      t.timestamps
    end
    add_index :stacks, :slug, unique: true
  end
end
