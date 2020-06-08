class Populate
	def initialize(array)
		@array = array
		populate_db
	end

	def populate_db
		@array.each {|pool_hash|
			# binding.pry
			if !(pool_hash['ticker'] == 'n/a')
				pool = find_create_pool(split_hash(pool_hash)[:pool])
				epoch = pool_hash['last_epoch']

				create_or_update_epoch(pool, epoch, split_hash(pool_hash)[:pool_epoch])
			end
		}
	end

	def find_create_pool(pool_hash)
		pool = Pool.find_by(address: pool_hash[:address])
		pool = Pool.create(
					ticker: pool_hash[:ticker],
					name: pool_hash[:name],
					address: pool_hash[:address]
		) if !pool
		print "#{pool.ticker} << "
		pool
	end

	def create_or_update_epoch(pool, epoch, hash)
		p_epochs = PoolEpoch.find_by(epoch: epoch)
		if p_epochs.class.to_s == 'Array' && p_epochs
			p_epoch = p_epochs.select{|pe| pe.pool.address == pool.address} if p_epochs
		elsif  p_epochs
			p_epoch = p_epochs.pool.address == pool.address ? p_epochs : nil
		end
		if !p_epoch
			p_epoch = PoolEpoch.create(hash)
			pool.pool_epochs << p_epoch
			puts "#{p_epoch.epoch} pool epoch CREATED."
		else
			p_epoch.update(hash)
			puts "#{p_epoch.epoch} pool epoch UPDATED."
		end
		p_epoch
	end

	def split_hash(hash)
		{pool_epoch: {
	      "pool_size": hash['pool_size'],
	      "epoch": hash['last_epoch'],
	      "blocks": hash['blocks'],
	      "staker_reward": hash['staker_reward'],
	      "total_stake": hash['live_stake'],
	      "tax": hash['tax']
	    },
	   pool: {
	   	ticker: hash['ticker'],
	   	name: hash['name'],
	   	address: hash['address']
	   }
		}

	end

end