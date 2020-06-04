class PoolEpoch < ActiveRecord::Base
	has_many(:delegations)
	belongs_to(:pool)
	has_many(:users, through: :delegations)
end
