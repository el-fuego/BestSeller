class Advert < ActiveRecord::Base
  belongs_to :manufacturer_model
  belongs_to :best_offer
end
