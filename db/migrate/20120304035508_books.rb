class Books < ActiveRecord::Migration
  def up
		create_table :books do |t|
			t.string :title
    	t.string :authors #Returns all authors as a comma delimited string
    	t.string :publisher
    	t.date :published_date
    	t.text :description
    	t.integer :isbn #Attempts to return 13-digit first, then 10-digit, then nil
    	t.integer :isbn_10 #Returns 10-digit form only
    	t.integer :isbn_13 #Returns 13-digit form only
    	t.integer :page_count
    	t.string :print_type
    	t.string :categories #Returns all categories as a comma delimited string
    	t.integer :average_rating
    	t.integer :ratings_count
    	t.string :language
    	t.string :preview_link
    	t.string :info_link
    	t.string :image_link

			t.timestamps
		end
  end

  def down
		drop_table :books
  end
end
