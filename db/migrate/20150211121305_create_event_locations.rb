class CreateEventLocations < ActiveRecord::Migration
  def change
    create_table :event_locations do |t|
      t.string :id_facebook
      t.string :name
      t.string :city
      t.string :street
      t.string :zip
      t.string :canton
      t.string :country
      t.float :latitude
      t.float :longitude
      t.string :category
      t.string :cover
      t.integer :likes
      t.string :link
      t.string :phone
      t.string :website

      t.timestamps
    end
  end
end
