class AddNickToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :nick, :string
  end

  def self.down
    remove_column :users, :nick
  end
end
