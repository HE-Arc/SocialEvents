class RemoveCoverFromEventLocations < ActiveRecord::Migration
  def change
    remove_column :event_locations, :cover, :string
  end
end
