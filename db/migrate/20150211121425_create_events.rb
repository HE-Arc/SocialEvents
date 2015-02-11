class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :id_facebook
      t.string :title
      t.string :picture
      t.string :category
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.references :user, index: true
      t.references :event_location, index: true

      t.timestamps
    end
  end
end
