class RenameModelIdToManufacturerModelIdAtAdvert < ActiveRecord::Migration
  def change
    rename_column :adverts, :model_id, :manufacturer_model_id
  end
end
