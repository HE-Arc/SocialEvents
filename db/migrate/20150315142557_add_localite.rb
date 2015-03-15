class AddLocalite < ActiveRecord::Migration
  def change
      create_table :localites do |t|
        t.string   "npa"
        t.string   "localite"
        t.string   "canton"
      end
  end
end