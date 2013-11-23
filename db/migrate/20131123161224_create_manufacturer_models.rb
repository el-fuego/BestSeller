class CreateManufacturerModels < ActiveRecord::Migration
  def change
    create_table :manufacturer_models do |t|
      t.string :name

      t.timestamps
    end
  end
end
