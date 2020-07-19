class AddGuestAuthorToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :guest_author, :boolean
  end
end
