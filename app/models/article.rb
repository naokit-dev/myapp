class Article < ApplicationRecord
  belongs_to :user 
  attribute :url_token, :string, default: SecureRandom.urlsafe_base64(8)
  attribute :guest_token, :string, default: SecureRandom.hex(4)
  # validates :url_token, presence: true, uniqueness: true

  def to_param
    url_token
  end


end

