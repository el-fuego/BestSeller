class AdvertsController < ApplicationController
  def index
    @adverts = []

    @adverts = Advert.joins :best_offer
    if params['model_id']
      @adverts = @adverts.model params['model_id']
    else
      @adverts = @adverts.model ManufacturerModel.where({manufacturer_id: params['manufacturer_id']}).map{|m|m.id} if params['manufacturer_id']
    end
    @adverts = @adverts.year params['year']  if params['year']

    @adverts = @adverts.where{best_offer.id != nil}.limit(100)
  end
end
