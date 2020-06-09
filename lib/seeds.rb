class Seed
  def initialize
    @u1 = User.create({username: 'sergio', email: 'uno@com.com', password: 'pw', balance: 10000})
    @u2 = User.create({username: 'ada', email: 'uno@com.com', password: 'pw', balance: 5000})
    @u3 = User.create({username: 'jem', email: 'uno@com.com', password: 'pw', balance: 33000})
    @u4 = User.create({username: 'mare', email: 'uno@com.com', password: 'pw', balance: 99000})

    min_ep = PoolEpoch.minimum('epoch')
    max_ep = PoolEpoch.maximum('epoch')


    @u1.pool_epochs = PoolEpoch.where('epoch <= ? AND epoch > ? AND pool_id = ?', max_ep, min_ep, 2)
    @u1.delegations.each {|d| 
      d.kind = 'wished'
      d.amount = @u1.balance
      d.save
    }
    @u1.pool_epochs = PoolEpoch.where('epoch <= ? AND epoch > ? AND pool_id = ?', max_ep, min_ep, 1)
    @u1.delegations.each {|d| 
      d.amount = @u1.balance
      d.save
    }

    @u2.pool_epochs = PoolEpoch.where('epoch <= ? AND epoch > ? AND pool_id = ?', max_ep, min_ep, 3)
    @u2.delegations.each {|d| 
      d.kind = 'wished'
      d.amount = @u2.balance
      d.save
    }
    @u2.pool_epochs = PoolEpoch.where('epoch <= ? AND epoch > ? AND pool_id = ?', max_ep, min_ep, 2)
    @u2.delegations.each {|d| 
      d.amount = @u2.balance
      d.save
    }


    @u3.pool_epochs = PoolEpoch.where('epoch <= ? AND epoch > ? AND pool_id = ?', max_ep, min_ep, 1)
    @u3.delegations.each {|d| 
      d.kind = 'wished'
      d.amount = @u3.balance
      d.save
    }
    @u3.pool_epochs = PoolEpoch.where('epoch <= ? AND epoch > ? AND pool_id = ?', max_ep, min_ep, 2)
    @u3.delegations.each {|d| 
      d.amount = @u3.balance
      d.save
    }


    @u4.pool_epochs = PoolEpoch.where('epoch <= ? AND epoch > ? AND pool_id = ?', max_ep, min_ep, 4)
    @u4.delegations.each {|d| 
      d.kind = 'wished'
      d.amount = @u4.balance
      d.save
    }
    @u4.pool_epochs = PoolEpoch.where('epoch <= ? AND epoch > ? AND pool_id = ?', max_ep, min_ep, 5)
    @u4.delegations.each {|d| 
      d.amount = @u4.balance
      d.save
    }
  end
end
