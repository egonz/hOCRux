class AddBetaKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :beta_key, :string

  end
end
