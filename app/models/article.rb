class Article < ApplicationRecord
  belongs_to :user 
  require 'hashie'

  def self.create_initial_articles
    articles = Hashie::Mash.load("app/initial_articles.yml")
    puts articles
    articles.each do |article|
      self.new(title: article.title, content: article.content)
    end
  end
end

