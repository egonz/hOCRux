class RemovePageNumberFromPages < ActiveRecord::Migration
  def up
		remove_column :pages, :page_number
  end

  def down
		add_column :pages, :page_number, :integer
  end
end
