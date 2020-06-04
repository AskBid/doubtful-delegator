class Pool < ActiveRecord::Base
	has_many(:pool_epochs)
end
