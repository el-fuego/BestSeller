class BestOffer < ActiveRecord::Base
  belongs_to :advert

  scope :model, lambda{ |id|
    where(manufacturer_model_id: id) if id
  }

  scope :year, lambda{ |year|
    where(manufacture_year: year) if year
  }
end
