class AdvertsController < ApplicationController
  def index
    @adverts = []

    # search by parameters
    @adverts = Advert
    if params['model_id'] && params['model_id'].to_i != 0
      @adverts = @adverts.from_model params['model_id']
    else
      @adverts = @adverts.from_model ManufacturerModel.where({manufacturer_id: params['manufacturer_id']}).map{|m|m.id} if params['manufacturer_id'] && params['manufacturer_id'].to_i != 0
    end
    @adverts = @adverts.year params['year']  if params['year'] && params['year'].to_i != 0

    # all count
    @all_adverts_count = (@adverts == Advert ? @adverts.all : @adverts).length

    # best_offers
    @adverts = @adverts.joins(:best_offer).where{best_offer.id != nil}.limit(100)
  end

  def settings
  end
end
