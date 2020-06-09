class User < ActiveRecord::Base
	has_secure_password
	has_many(:delegations)
	has_many(:pool_epochs, through: :delegations)

	validates :email, :username, :password, :balance, presence: { message: "must be given please" }
	validates_uniqueness_of :username

	def slug
		self.username.gsub(' ', '-')
	end

	def self.find_by_slug(slug)
  	slug = slug.gsub('-', ' ')
  	self.find_by(username: slug)
  end
end
