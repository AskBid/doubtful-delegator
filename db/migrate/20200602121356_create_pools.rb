class CreatePools < ActiveRecord::Migration
  def change
    create_table :pools do |t|
    	t.string :ticker
    	t.string :name
    	t.string :address
    	
      t.timestamps null: false
    end
  end
end
