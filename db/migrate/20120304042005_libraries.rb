class Libraries < ActiveRecord::Migration
  def up
		create_table :libraries do |t|
			t.string :name
			t.integer :user_id

			t.timestamps
		end
  end

  def down
		drop_table :libraries
  end
end
