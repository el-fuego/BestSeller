class AdvertsController < ApplicationController
  def index
    @adverts = []

    # search by parameters
    @adverts = Advert
    if params['model_id'] && params['model_id'].to_i != 0
      @adverts = @adverts.from_model params['model_id'].to_i
    else
      @adverts = @adverts.from_model ManufacturerModel.where({manufacturer_id: params['manufacturer_id']}).map{|m|m.id} if params['manufacturer_id'] && params['manufacturer_id'].to_i != 0
    end
    @adverts = @adverts.year params['year'].to_i  if params['year'] && params['year'].to_i != 0
    @adverts = @adverts.max_price params['max_price'].to_i  if params['max_price'] && params['max_price'].to_i != 0
    @adverts = @adverts.cleared_only if params['cleared_only'] && params['cleared_only'] == 'on'

    # all count
    @all_adverts_count = (@adverts == Advert ? @adverts.all : @adverts).length

    # best_offers
    @adverts = @adverts.joins(:best_offer).where{best_offer.id != nil}.limit(100)
  end

  def settings
  end
end
