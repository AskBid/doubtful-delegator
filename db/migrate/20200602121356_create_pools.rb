class CreatePools < ActiveRecord::Migration
  def change
    create_table :pools do |t|
    	t.string :ticker
    	t.string :name
    	t.string :address
    	t.float :pool_size
    	t.integer :total_stake
    	t.integer :staker_rewards
    	t.integer :pool_reward
    	
      t.timestamps null: false
    end
  end
end
