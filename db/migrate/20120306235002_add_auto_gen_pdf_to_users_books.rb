class AddAutoGenPdfToUsersBooks < ActiveRecord::Migration
  def change
    add_column :user_books, :auto_gen_pdf, :boolean

  end
end
