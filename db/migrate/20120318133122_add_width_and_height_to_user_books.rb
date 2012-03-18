class AddWidthAndHeightToUserBooks < ActiveRecord::Migration
  def change
    add_column :user_books, :width, :integer

    add_column :user_books, :height, :integer

  end
end
