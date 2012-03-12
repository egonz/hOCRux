class Pages < ActiveRecord::Migration
  def up
		create_table :pages do |t|
			t.integer :user_book_id
			t.string :file_name
			t.integer :page_number
			t.boolean :processed

			t.timestamps
		end
  end

  def down
		drop_table :pages
  end
end
