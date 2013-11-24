class ManufacturerModel < ActiveRecord::Base
  belongs_to :manufacturer
  has_many :adverts
end
