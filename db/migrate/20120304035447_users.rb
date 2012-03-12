class Users < ActiveRecord::Migration
  def up
		create_table :users do |t|
      t.string :first_name
      t.string :last_name
			t.string :email
			t.string :facebook_id
			t.boolean :verified
			t.boolean :admin

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
