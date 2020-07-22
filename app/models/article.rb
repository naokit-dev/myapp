class Article < ApplicationRecord
  belongs_to :user 
  has_secure_password :guest_token, validations: true
  attribute :url_token, :string, default: -> { SecureRandom.urlsafe_base64(8) }
  before_save :create_guest_token


  def to_param
    url_token
  end
  
  private
  def create_guest_token
    self.guest_token = SecureRandom.hex(4)
  end
end