class Article < ApplicationRecord
  belongs_to :user 
  has_secure_password :article_token, validations: true
  attribute :url_token, :string, default: -> { SecureRandom.urlsafe_base64(8) }
  attribute :title, :text, default: "No title"
  attribute :content, :text, default:           "# What's mdClip??\r\n## Online Markdown editor\r\n\r\n```\r\nclass mdClip\r\n\r\ndef mdclip(your_code)\r\n  if you.want_to_share.codes == true\r\n    highlighted_code = mdClip.generate.easy(your_code)\r\n    shareable_url = mdClip.generate.quick(your_code)\r\n  end\r\nend \r\n\r\n```\r\n\r\n- Multi languages surport\r\n- Generate private URL\r\n- Stock your `codes`, notes (need to sign up)\r\n\r\n**Fun with Code, Enjoy Markdown**" 
  before_validation :create_article_token
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true

  def self.search(search)
    if search
      self.where(['title LIKE ? or content LIKE ?', "%#{search}%", "%#{search}%"])
    else
      self.all
    end
  end

  def to_param
    url_token
  end
  
  private
  def create_article_token
    self.article_token = SecureRandom.hex(4)
  end
end
