class Edocs < ActiveRecord::Migration
  def up
		create_table :edocs do |t|
			t.integer :user_book_id
			t.string :file_name
			t.string :doc_type

			t.timestamps
		end
  end

  def down
		drop_tables :edocs
  end
end
