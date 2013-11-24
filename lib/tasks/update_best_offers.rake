# encoding: utf-8
require 'rubygems'


namespace :best_offers do


  task :clear => :environment do
    BestOffer.delete_all
  end

  task :find => :environment do

    ManufacturerModel.all.each do |model|

      # puts model.name

      adverts = model.adverts

      # goto next if adverts count < minimal
      if adverts.length > 2 then
        price = get_average_price adverts.map{|a|a.price}

        # add to BestOffer adverts with lower price
        adverts.select{|a| a.price < price}.each do |a|
          puts "#{a.manufacturer.name} #{a.manufacturer_model.name} #{a.manufacture_year}"
          BestOffer.new({advert_id: a.id, price_difference: price - a.price}).save!
        end
      end
    end
  end


  def get_average_price(prices, step_coefficient = 0.1, same_prices_count_coefficient = 0.6)
    prices_groups = {}

    # group prices
    max_price = prices.max
    prices.each do |p|
      group = get_price_group p, max_price, step_coefficient
      prices_groups[group] = [] if prices_groups[group] == nil
      prices_groups[group] << price
    end

    # get max price items group
    max_length = prices_groups.max{|g| g.length}

    # all prices was grouped to single group
    return if max_length == prices.length

    # search with widest price group
    return get_average_price prices, step_coefficient*2 if prices.length < max_length * items_with_same_price_coefficient

    prices_groups.find{|g| g == max_length}.reduce(:+)
  end

  def get_price_group(price, max_price, step_coefficient)
    (price / max_price).div step_coefficient
  end

end