class User < ActiveRecord::Base
	has_secure_password
	has_many(:delegations)
	has_many(:pools, through: :delegations)
	has_many(:pool_epochs, through: :delegations)
end
