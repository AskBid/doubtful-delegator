class CreatePoolEpoches < ActiveRecord::Migration
  def change
    create_table :pool_epoches do |t|
    	t.float   :pool_size
    	t.integer :total_stake
    	t.integer :staker_reward
    	t.integer :pool_reward
    	t.integer :epoch
    	t.integer :blocks
    	t.float   :tax

      t.timestamps null: false
    end
  end
end
