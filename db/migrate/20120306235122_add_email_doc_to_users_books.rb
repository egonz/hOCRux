class AddEmailDocToUsersBooks < ActiveRecord::Migration
  def change
    add_column :user_books, :email_doc, :boolean

  end
end
