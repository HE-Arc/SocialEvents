class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :id_facebook, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :city, :string
    add_column :users, :birthday, :date
    add_column :users, :gender, :string
  end
end
