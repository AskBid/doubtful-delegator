class Pool < ActiveRecord::Base
	has_many(:delegations)
	has_many(:pool_epochs, through: :delegations)
	has_many(:users, through: :delegations)
end
