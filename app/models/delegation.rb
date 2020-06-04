class Delegation < ActiveRecord::Base
	belongs_to(:pool)
	belongs_to(:pool_epoch)
	belongs_to(:user)
end
