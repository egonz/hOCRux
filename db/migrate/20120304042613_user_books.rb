class UserBooks < ActiveRecord::Migration
  def up
		create_table :user_books do |t|
			t.integer :user_id
			t.integer :book_id
			t.integer :library_id

			t.timestamps
		end
  end

  def down
		drop_table :user_books
  end
end
