class Populate
	def initialize(array)
		@array = array
		populate_db
	end

	def populate_db
		array.each {|pool_hash|
			if !(pool_hash[:ticker] == 'n/a')
				pool = find_create_pool(pool_hash)
				epoch = pool_hash[:last_epoch]

				create_or_update_epoch(pool, epoch, pool_hash)
			end
		}
	end

	def find_create_pool(hash)
		pool = Pool.find_by(address: pool_hash[:address])
				pool = Pool.create(
					ticker: pool_hash[:ticker],
					name: pool_hash[:name],
					address: pool_hash[:address]
		) if !pool
	end

	def create_or_update_epoch(pool, epoch, hash)
		p_epoch = PoolEpoch.find_by(epoch: epoch).select { |pe|
			pe.pool.address == pool.address
		}
		if !p_epoch
			p_epoch = PoolEpoch.create(split_hash(hash))
			pool.pool_epochs << p_epoch
		else
			p_epoch.update(split_hash(hash))
		end
		p_epoch
	end

	def split_hash(hash)
		{
      "pool_size": hash[:pool_size],
      "last_epoch": hash[:last_epoch],
      "blocks": hash[:blocks],
      "staker_reward": hash[:staker_reward],
      "live_stake": hash[:live_stake],
      "tax": hash[:tax]
    }
	end

end