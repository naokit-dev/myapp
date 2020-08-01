class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.string :url_token
      t.string :article_token_digest
      t.timestamps
    end
  end
end
