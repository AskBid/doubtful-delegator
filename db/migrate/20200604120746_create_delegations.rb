class CreateDelegations < ActiveRecord::Migration
  def change
    create_table :delegations do |t|
    	t.string :type
    	t.integer :amount
    	t.integer :user_id
    	t.integer :pool_id
    	t.integer :pool_epoch_id

      t.timestamps null: false
    end
  end
end
