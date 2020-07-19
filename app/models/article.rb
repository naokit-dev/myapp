class Article < ApplicationRecord
  belongs_to :user 
  attribute :url_token, :string, default: -> { SecureRandom.urlsafe_base64(8) }
  # attribute :guest_token, :string, default: -> { SecureRandom.hex(4) }
  # attr_accessor :guest_token, :string
  attribute :guest_author, :boolean, default: false
  # validates :url_token, presence: true, uniqueness: true
  
  def to_param
    url_token
  end
  
  has_secure_password :guest_token, validations: true
end