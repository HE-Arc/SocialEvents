class AddIsFetchingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_fetching, :boolean, :default => false
  end
end
