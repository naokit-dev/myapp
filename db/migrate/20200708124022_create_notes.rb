class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.text :title
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :notes, [:user_id, :created_at]
  end
end
