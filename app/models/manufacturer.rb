class Manufacturer < ActiveRecord::Base
  has_many :adverts, :through => :manufacturer_models
end
