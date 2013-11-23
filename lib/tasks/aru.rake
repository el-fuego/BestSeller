# для получения контента через http
require 'open-uri'
# подключаем Nokogiri
require 'nokogiri'

    # t.integer  "manufacturer_model_id"
    # t.integer  "manufacture_year"
    # t.datetime "advert_created_at"
    # t.text     "url"
    # t.text     "image_url"
    # t.text     "thumbnail_url"
    # t.boolean  "is_cleared"
    # t.boolean  "is_demaged"
    # t.datetime "created_at"
    # t.datetime "updated_at"
    # t.integer  "price"



namespace :aru do
  desc "grab adv from auto.ria.ua"
  
  task :grab => :environment do
    # i dont know what "=> :environment" mean
    p "grabber is runned"
    getAdvHtmlBlock('10122766')
    
    # for i in getTopIds()
      # p getAdvHtmlBlock(i)
    # end
   
  end
  
  def getTopIds()
    return ['10122766', '11175983', '9628547', '9151332', '8531964'];
    # url = 'http://auto.ria.ua/blocks_search_ajax/search/?bodystyle=0&countpage=100&category_id=1&view_type_id=0&page=0&marka=0&model=0&s_yers=0&po_yers=0&state=0&city=0&price_ot=&price_do=&currency=1&gearbox=0&type=0&drive_type=0&door=0&color=0&metallic=0&engineVolumeFrom=&engineVolumeTo=&raceFrom=&raceTo=&powerFrom=&powerTo=&power_name=1&fuelRateFrom=&fuelRateTo=&fuelRatesType=city&custom=0&damage=0&saledParam=0&under_credit=0&confiscated_car=0&auto_repairs=0&with_exchange=0&with_real_exchange=0&exchangeTypeId=0&with_photo=0&with_video=0&is_hot=0&vip=0&checked_auto_ria=0&top=0&order_by=0&hide_black_list=0&auto_id=&auth=0&deletedAutoSearch=0&user_id=0&scroll_to_auto_id=0&expand_search=0&can_be_checked=0&last_auto_id=0&matched_country=-1&seatsFrom=&seatsTo=&wheelFormulaId=0&axleId=0&carryingTo=&carryingFrom=&search_near_states=0'
    # # получаем содержимое веб-страницы в объект
    # jsonData = JSON.parse(open(url.to_s).read())
    # return jsonData['result']['search_result']['ids']
  end

  def getAdvHtmlBlock(id)
    url = 'http://auto.ria.ua/blocks_search/view/auto/{adv_id}/?lang_id=2&view_type_id=0&strategy=default&domain_zone=ua&user_id=2305539'
    url = url.sub! "{adv_id}", id
    page = Nokogiri::HTML(open(url.to_s))
    usd_price = page.css('div.price').css('strong.green').first.text
    full_name = page.css('h3.head-car').css('a').first.text    
    tiket_photo = page.xpath('//div/a/img/@src').first.value.strip!
    phone = page.css('span.phone').first.text
    adv_url = 'http://auto.ria.ua' + page.css('h3.head-car').css('a')[0]['href']
    p "url: " + adv_url
    p "photo" + tiket_photo
    p "name: " + full_name
    p "price: " + usd_price
    p "phone: " + phone
    return page
  end
   
end