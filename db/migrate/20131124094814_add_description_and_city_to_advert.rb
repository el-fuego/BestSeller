class AddDescriptionAndCityToAdvert < ActiveRecord::Migration
  def change
    add_column :adverts, :description, :text
    add_column :adverts, :city, :string
  end
end
