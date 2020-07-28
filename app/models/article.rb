class Article < ApplicationRecord
  belongs_to :user 
  has_secure_password :article_token, validations: true
  attribute :url_token, :string, default: -> { SecureRandom.urlsafe_base64(8) }
  before_validation :create_article_token
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true

  def to_param
    url_token
  end
  
  private
  def create_article_token
    self.article_token = SecureRandom.hex(4)
  end
end
