class Delegation < ActiveRecord::Base
	belongs_to(:pool_epoch)
	belongs_to(:user)

	# validates :kind, presence: ['wished', 'delegated', nil]
	validates_uniqueness_of :kind, scope: [:user_id, :pool_epoch_id]
end