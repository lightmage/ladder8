class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string  :name, :name_parameterized
      t.integer :slots
    end
  end
end
