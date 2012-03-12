class AddTotalPagesToUserBooks < ActiveRecord::Migration
  def change
    add_column :user_books, :total_pages, :integer

  end
end
