class User < ApplicationRecord
  validates :username, presence: true, length: { maximum: 12 }
  validates :email, presence: true
  validates :password, presence: true, length: { minimum: 8 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :articles, dependent: :destroy

  def self.guest
    find_or_create_by(email: "test_user@mail.com") do |user|
      user.username = "Guest_user"
      user.password = 12345678
    end
  end

end
