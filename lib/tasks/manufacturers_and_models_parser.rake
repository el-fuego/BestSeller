# encoding: utf-8
require 'rubygems'
require 'open-uri'
require 'json/pure'

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
        #puts "    #{n.to_s}"

        ManufacturerModel.new({:name => n, :manufacturer_id => a.id}).save!
      end
    end
  end

  def get_cookie
    if !@cookie
      #h1 = open("http://auto.ria.ua")
      #h1.read()
      #puts h1.meta
      #@cookie = h1.meta['set-cookie'].split('; ', 2)[0]
      @cookie = 'sess_auto_id=12455352; PHPSESSID=g17ro8s9v10tnc0mhd5hguari0; ui=eeffa457bc34b09; __utma=1.1190002571.1385053860.1385053860.1385053860.1; __utmc=1; __utmz=1.1385053860.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); view_type=tabs1; newdesign=1; CCC=0%3A0%3A0; sess_auto_id=12524084; last_auto_id=12524390; sess_news_id=210931; last_news_id=210931; MY_STATE_ID=0; MY_CITY_ID=0; siteSettings=%7B%22currBoxShort%22%3A%5Bfalse%5D%7D; ipp=100; __utma=15931942.1237634177.1384867819.1385758598.1385758598.12; __utmb=15931942.11.0.1385803089207; __utmc=15931942; __utmz=15931942.1385758598.9.5.utmcsr=localhost:3000|utmccn=(referral)|utmcmd=referral|utmcct=/; lang_code=ru'
    end
    @cookie
  end

  def load_models (manufacturer_id)


    result = open(
        "http://auto.ria.ua/ajax.php?target=auto&event=load_subcategory&marka_id=#{manufacturer_id}&lang_id=2&category_id=0&is_hot=0&under_credit=0&matched_country=-1&checked_auto_ria=0&with_exchange=1",
        "Cookie" => get_cookie
    ).read()

    result.force_encoding Encoding::UTF_8


    hash = JSON.parse result

    hash["modelArr"].map{|m|m['name'].to_s.strip}
  end

end