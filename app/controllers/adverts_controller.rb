class AdvertsController < ApplicationController
  def index
    response.headers["X-Frame-Options"] = "Allow-From http://www.website.com"
    @adverts = []

    @adverts = Advert.joins :best_offer
    if params['model_id'] && params['model_id'].to_i != 0
      @adverts = @adverts.from_model params['model_id']
    else
      @adverts = @adverts.from_model ManufacturerModel.where({manufacturer_id: params['manufacturer_id']}).map{|m|m.id} if params['manufacturer_id'] && params['manufacturer_id'].to_i != 0
    end
    @adverts = @adverts.year params['year']  if params['year'] && params['year'].to_i != 0

    @adverts = @adverts.where{best_offer.id != nil}.limit(100)
  end

  def settings
    response.headers["X-Frame-Options"] = "Allow-From http://www.website.com"
  end
end
