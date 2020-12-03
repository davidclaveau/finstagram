class User < ActiveRecord::Base

    has_many :finstagram_posts
    has_many :comments
    has_many :likes

    validates :email, :username, uniqueness: true
    validates :email, :avatar_url, :username, :password, presence: true
    validates :username, :password, length: { in: 6..20 }

    include ActiveModel::Validations
    validates_with MyValidator

end