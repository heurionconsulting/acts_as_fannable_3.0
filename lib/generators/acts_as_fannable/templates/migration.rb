class CreateFans < ActiveRecord::Migration
  def change
    create_table :fans, :force => true do |t|
      t.integer :fannable_id,:default => 0, :null => false
      t.string :fannable_type,:default => "", :null => false
      t.integer :user_id,:default => 0, :null => false
      t.timestamps
    end
    add_index(:fans, [:user_id], :name => "fk_fans_user")
  end

end
