@u1 = User.create({username: 'sergio', email: 'uno@com.com', password: 'pw', balance: 10000})
@u2 = User.create({username: 'ada', email: 'uno@com.com', password: 'pw', balance: 5000})
@u3 = User.create({username: 'jem', email: 'uno@com.com', password: 'pw', balance: 33000})

@p1 = Pool.create({ "ticker": "BCSH",
                    "name": "Blue Cheese Stake House",
                    "address": "634f6d2be73e85db13a934523b6958947ca21c3449bd5af8469dbdce49731930"
                  })
@e1p1 = PoolEpoch.create({"pool_size": 1.0,
                          "epoch": 172,
                          "blocks": 31,
                          "staker_reward": 34200,
                          "total_stake": 128610000,
                          "tax": 1.0
                        })
@e2p1 = PoolEpoch.create({"pool_size": 1.0,
                          "epoch": 173,
                          "blocks": 7,
                          "staker_reward": 34800,
                          "total_stake": 128610000,
                          "tax": 1.0
                        })


@p2 = Pool.create({ "ticker": "FMCA3",
                    "name": "FMCA3",
                    "address": "f6b0dbaf5106167eea7b94c3b42aafbde5c11e47fac5f9b378c3aadc43e13f24"
                  })
@e1p2 = PoolEpoch.create({  "pool_size": 0.97,
                            "epoch": 172,
                            "blocks": 30,
                            "staker_reward": 32800,
                            "total_stake": 125360000,
                            "tax": 5.0
                          })
@e2p2 = PoolEpoch.create({  "pool_size": 0.97,
                            "epoch": 173,
                            "blocks": 6,
                            "staker_reward": 33800,
                            "total_stake": 125360000,
                            "tax": 5.0
                          })


@p3 = Pool.create({ "ticker": "AAA",
                    "name": "AAA Stake Pool",
                    "address": "842c9317cb20b8b1cd05e17b03415b6bd0292823b3e4eff048dc2f7c78642c54"
                  })
@e1p3 = PoolEpoch.create({"pool_size": 0.97,
                          "epoch": 172,
                          "blocks": 31,
                          "staker_reward": 28200,
                          "total_stake": 125090000,
                          "tax": 0.0
                        })
@e2p3 = PoolEpoch.create({"pool_size": 0.97,
                          "epoch": 173,
                          "blocks": 7,
                          "staker_reward": 28500,
                          "total_stake": 125090000,
                          "tax": 0.0
                        })

@e1p1.pool = @p1
@e2p1.pool = @p1

@e1p2.pool = @p2
@e2p2.pool = @p2

@e1p3.pool = @p3
@e2p3.pool = @p3

@u1.pool_epochs = [@e1p1, @e2p1]
@u2.pool_epochs = [@e1p2, @e2p2]
@u3.pool_epochs = [@e2p1, @e2p3]

@u1.save
@u2.save
@u3.save
@e1p1.save
@e2p1.save
@p1.save

@e1p2.save
@e2p2.save
@p2.save

@e1p3.save
@e2p3.save
@p3.save

