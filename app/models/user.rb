class User < ActiveRecord::Base
	has_secure_password validations: false
	has_many(:delegations)
	has_many(:pool_epochs, through: :delegations)

	validates :email, presence: { message: "%{attribute} must be given" }
	validates :username, presence: { message: "%{attribute} must be a number" }
	validates :password, presence:  { message: "Password must be a given" }
	validates :balance,  numericality: { message: "%{attribute} must be a number" }
	validates_uniqueness_of :username, {message: "%{value} username already exist"}

	def slug
		self.username.gsub(' ', '-')
	end

	def self.find_by_slug(slug)
  	slug = slug.gsub('-', ' ')
  	self.find_by(username: slug)
  end
end
