class AddGuestTokenDigestToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :guest_token_digest, :string
  end
end
