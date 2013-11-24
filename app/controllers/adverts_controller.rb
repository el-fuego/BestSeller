class AdvertsController < ApplicationController
  def index
    @adverts = []
    offers = BestOffer.order('price_difference DESC').limit(100)
    @adverts = offers.map{:advert} if !offers.empty?
  end
end
