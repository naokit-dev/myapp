class AddGuestTokenToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :guest_token, :string
  end
end
