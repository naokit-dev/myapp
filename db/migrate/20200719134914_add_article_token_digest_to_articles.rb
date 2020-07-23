class AddArticleTokenDigestToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :article_token_digest, :string
  end
end
