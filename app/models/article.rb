class Article < ApplicationRecord
  belongs_to :user 
  has_secure_password :guest_token, validations: true
  attribute :url_token, :string, default: -> { SecureRandom.urlsafe_base64(8) }
  # attribute :guest_token, :string, default: -> { SecureRandom.hex(4) }
  # attr_accessor :guest_token, :string
  attribute :guest_author, :boolean, default: false
  # validates :url_token, presence: true, uniqueness: true



  def self.create_guest_token
    self.guest_token = SecureRandom.hex(4)
  end



  def to_param
    url_token
  end

end