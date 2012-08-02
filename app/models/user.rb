class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

  before_save { self.email.downcase! }
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\.-]+@[a-z\d\.-]+\.[a-z]+\z/i

  validates :email, presence: true, 
                    format:     { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 50 }
  validates :password, presence: true,
                       length: { minimum: 6 }
  validates :password_confirmation, presence: true
end
