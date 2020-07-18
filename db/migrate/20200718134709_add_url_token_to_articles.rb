class AddUrlTokenToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :url_token, :string
  end
end
