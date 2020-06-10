class Seed
  def initialize
    u1 = User.create({username: 'sergio', email: 'uno@com.com', password: 'pw', balance: 10000})
    if !u1.save
      u1 = User.find_by({username: 'sergio'})
    end
    u2 = User.create({username: 'ada', email: 'uno@com.com', password: 'pw', balance: 5000})
    if !u1.save
      u2 = User.find_by({username: 'ada'})
    end
    u3 = User.create({username: 'jem', email: 'uno@com.com', password: 'pw', balance: 33000})
    if !u1.save
      u3 = User.find_by({username: 'jem'})
    end
    u4 = User.create({username: 'mare', email: 'uno@com.com', password: 'pw', balance: 99000})
    if !u1.save
      u4 = User.find_by({username: 'mare'})
    end


    min_ep = PoolEpoch.minimum('epoch')
    max_ep = PoolEpoch.maximum('epoch')


    u1.pool_epochs = PoolEpoch.where('epoch <= ? AND epoch >= ? AND pool_id = ?', max_ep, min_ep, 2)
    u1.delegations.each {|d| 
      d.kind = 'wished'
      d.amount = 1
      d.save
    }
    u1.pool_epochs << PoolEpoch.where('epoch <= ? AND epoch >= ? AND pool_id = ?', max_ep, min_ep, 1)
    u1.delegations.joins(:pool_epoch).where('pool_id = ?', 1).each {|d| 
      d.kind = 'delegated'
      d.amount = 1
      d.save
    }

    u2.pool_epochs = PoolEpoch.where('epoch <= ? AND epoch >= ? AND pool_id = ?', max_ep, min_ep, 3)
    u2.delegations.each {|d| 
      d.kind = 'wished'
      d.amount = 1
      d.save
    }
    u2.pool_epochs << PoolEpoch.where('epoch <= ? AND epoch >= ? AND pool_id = ?', max_ep, min_ep, 2)
    u2.delegations.joins(:pool_epoch).where('pool_id = ?', 2).each {|d| 
      d.kind = 'delegated'
      d.amount = 1
      d.save
    }


    u3.pool_epochs = PoolEpoch.where('epoch <= ? AND epoch >= ? AND pool_id = ?', max_ep, min_ep, 1)
    u3.delegations.each {|d| 
      d.kind = 'wished'
      d.amount = 1
      d.save
    }
    u3.pool_epochs << PoolEpoch.where('epoch <= ? AND epoch >= ? AND pool_id = ?', max_ep, min_ep, 2)
    u3.delegations.joins(:pool_epoch).where('pool_id = ?', 2).each {|d| 
      d.kind = 'delegated'
      d.amount = 1
      d.save
    }


    u4.pool_epochs = PoolEpoch.where('epoch <= ? AND epoch >= ? AND pool_id = ?', max_ep, min_ep, 4)
    u4.delegations.each {|d| 
      d.kind = 'wished'
      d.amount = 1
      d.save
    }
    u4.pool_epochs << PoolEpoch.where('epoch <= ? AND epoch >= ? AND pool_id = ?', max_ep, min_ep, 5)
    u4.delegations.joins(:pool_epoch).where('pool_id = ?', 5).each {|d| 
      d.kind = 'delegated'
      d.amount = 1
      d.save
    }
  end
end
