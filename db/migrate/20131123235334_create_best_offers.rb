class CreateBestOffers < ActiveRecord::Migration
  def change
    create_table :best_offers do |t|
      t.integer :advert_id
      t.integer :price_difference

      t.timestamps
    end
  end
end
