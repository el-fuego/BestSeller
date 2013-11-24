class AdvertsController < ApplicationController
  def index
    @adverts = []

    offers = BestOffer
    if params['model_id']
      offers = offers.model params['model_id']
    else
      offers = offers.model ManufacturerModel.where({manufacturer_id: params['manufacturer_id']}).map{|m|m.id} if params['manufacturer_id']
    end
    offers = offers.year params['year']  if params['year']

    offers = offers.limit(100)
    @adverts = offers.map{|o| o.advert} if !offers.empty?
  end
end
