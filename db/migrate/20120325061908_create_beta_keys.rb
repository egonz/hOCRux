class CreateBetaKeys < ActiveRecord::Migration
  def up
  	create_table :beta_keys do |t|
      t.string :key

      t.timestamps
    end
  end

  def down
    drop_table :beta_keys
  end
end
