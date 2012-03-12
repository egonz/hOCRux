class AddLastPagePageNoToPages < ActiveRecord::Migration
  def change
    add_column :pages, :page_no, :integer

    add_column :pages, :last_page, :boolean

  end
end
