# encoding: utf-8
require 'rubygems'

namespace :manufacturers_and_models do

  task :clear_all => :environment do
    Manufacturer.delete_all
    ManufacturerModel.delete_all
  end

  task :clear_models => :environment do
    ManufacturerModel.delete_all
  end


  task :load => :environment do
    manufacturers = JSON.parse  File.read("lib/tasks/auto_ria_manufacturers.json")

    manufacturers.each do |k,v|
      puts v
      a = Manufacturer.new({:name => v})
      a.save!

      load_models(k).each do |n|
        puts "    #{n.to_s}"
        ManufacturerModel.new({:name => n, :manufacturer_id => a.id}).save!
      end
    end
  end


  def load_models (manufacturer_id)
    require 'net/http'
    result = Net::HTTP.get(URI.parse("http://auto.ria.ua/ajax.php?target=auto&event=load_subcategory&marka_id=#{manufacturer_id}&lang_id=2&category_id=0&is_hot=0&under_credit=0&matched_country=-1&checked_auto_ria=0&with_exchange=1"))
    require 'json'
    hash = JSON.parse result

    hash["modelArr"].map{|m|m['name']}
  end

end