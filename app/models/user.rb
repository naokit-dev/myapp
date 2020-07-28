class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true, length: { maximum: 12 }
  validates :email, presence: true
  validates :password, presence: true, length: { minimum: 8 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :articles, dependent: :destroy

  def self.guest
    find_or_create_by(email: "test_user@mail.com") do |user|
      user.username = "Guest"
      user.password = 12345678
    end
  end

  def self.mdguest
    find_or_create_by(username: "mdGuest") do |user|
      user.username = "mdGuest"
      user.email = "#{SecureRandom.hex(10)}@mduser.com"
      user.password = SecureRandom.hex(10)
    end
  end

  def is_guest_author?
    if self.username == "mdGuest"
      return true
    else
      false
    end
  end
end
