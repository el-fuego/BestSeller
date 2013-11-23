class AddManufatcurerIdToManufacturerModel < ActiveRecord::Migration
  def change
    add_column :manufacturer_models, :manufacturer_id, :integer
  end
end
