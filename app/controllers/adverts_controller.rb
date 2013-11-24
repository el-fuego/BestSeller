class AdvertsController < ApplicationController
  def index
    @adverts = []

    @adverts = Advert
    if params['model_id'] && params['model_id'].to_i != 0
      @adverts = @adverts.from_model params['model_id']
    else
      @adverts = @adverts.from_model ManufacturerModel.where({manufacturer_id: params['manufacturer_id']}).map{|m|m.id} if params['manufacturer_id'] && params['manufacturer_id'].to_i != 0
    end
    @adverts = @adverts.year params['year']  if params['year'] && params['year'].to_i != 0

    @all_adverts_count = (@adverts == Advert ? @adverts.all : @adverts).length

    @adverts = @adverts.joins(:best_offer).where{best_offer.id != nil}.order('advert_created_at DESC').limit(100)
  end

  def settings
  end
end
