class CreateAdverts < ActiveRecord::Migration
  def change
    create_table :adverts do |t|
      t.integer :manufacturer_id
      t.integer :model_id
      t.integer :manufacture_year
      t.datetime :advert_created_at
      t.text :url
      t.text :image_url
      t.text :thumbnail_url
      t.boolean :is_cleared
      t.boolean :is_demaged

      t.timestamps
    end
  end
end
