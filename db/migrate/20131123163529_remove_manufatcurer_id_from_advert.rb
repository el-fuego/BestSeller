class RemoveManufatcurerIdFromAdvert < ActiveRecord::Migration
  def change
    remove_column :adverts, :manufacturer_id, :integer
  end
end
