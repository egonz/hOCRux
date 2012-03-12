class AddPdfFileToPages < ActiveRecord::Migration
  def change
    add_column :pages, :pdf_file, :string
  end
end
