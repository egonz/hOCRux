class Subscribers < ActiveRecord::Migration
  def up
		create_table :subscribers do |t|
			t.integer :user_id
			t.timestamps
		end
  end

  def down
		drop_table :subscribers
  end
end
