class AddHashKeyToUserBooks < ActiveRecord::Migration
  def change
    add_column :user_books, :hash_key, :string

  end
end
