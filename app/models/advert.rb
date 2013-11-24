class Advert < ActiveRecord::Base
  belongs_to :manufacturer_model
  has_one :best_offer
  belongs_to :manufacturer
end
