class RenameFileNameForPages < ActiveRecord::Migration
  def up
		rename_column :pages, :file_name, :processed_image
  end

  def down
		rename_column :pages, :processed_image, :file_name
  end
end
