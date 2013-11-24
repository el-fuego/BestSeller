# для получения контента через http
require 'open-uri'
# подключаем Nokogiri
require 'nokogiri'
require 'tasks/get_model.rb'


namespace :aru do
  desc "grab adv from auto.ria.ua"
  
  task :grab => :environment do
    # i dont know what "=> :environment" mean
    p "grabber is runned"
    getAdvHtmlBlock('10122766')
    # for i in getTopIds()
      # getAdvHtmlBlock(i)
    # end
   
  end
  
  def getTopIds(page_id=0)
    # return ['10122766', '11175983', '9628547', '9151332', '8531964'];
    url = 'http://auto.ria.ua/blocks_search_ajax/search/?bodystyle=0&countpage=100&category_id=1&view_type_id=0&page={page_id}&marka=0&model=0&s_yers=0&po_yers=0&state=0&city=0&price_ot=&price_do=&currency=1&gearbox=0&type=0&drive_type=0&door=0&color=0&metallic=0&engineVolumeFrom=&engineVolumeTo=&raceFrom=&raceTo=&powerFrom=&powerTo=&power_name=1&fuelRateFrom=&fuelRateTo=&fuelRatesType=city&custom=0&damage=0&saledParam=0&under_credit=0&confiscated_car=0&auto_repairs=0&with_exchange=0&with_real_exchange=0&exchangeTypeId=0&with_photo=0&with_video=0&is_hot=0&vip=0&checked_auto_ria=0&top=0&order_by=0&hide_black_list=0&auto_id=&auth=0&deletedAutoSearch=0&user_id=0&scroll_to_auto_id=0&expand_search=0&can_be_checked=0&last_auto_id=0&matched_country=-1&seatsFrom=&seatsTo=&wheelFormulaId=0&axleId=0&carryingTo=&carryingFrom=&search_near_states=0'
    url = url.sub! "{page_id}", page_id.to_s
    # получаем содержимое веб-страницы в объект
    jsonData = JSON.parse(open(url.to_s).read())
    return jsonData['result']['search_result']['ids']
  end

  def getAdvHtmlBlock(id)
    p "processing " + id
    
    url = 'http://auto.ria.ua/blocks_search/view/auto/{adv_id}/?lang_id=2&view_type_id=0&strategy=default&domain_zone=ua&user_id=2305539'
    url = url.sub! "{adv_id}", id
    filename = '/tmp/car_'+id+'.html'
    p "filename " + filename
    html = ''
    if (File.exist?(filename))
      p "file exists"
      file = File.open(filename, "rb")
      html = file.read
    else
      html = open(url.to_s).read()          
      File.open('/tmp/car_'+id+'.html', 'w') {|file| file.write(html)}
    end

    page = Nokogiri::HTML(html)
    #page = Nokogiri::HTML(open(url.to_s))
    
    begin
      usd_price = page.css('div.price').css('strong.green').first.text
    rescue Exception
      return
    end  
    
    
    
    usd_price = usd_price.split.join
        
    full_name = page.css('h3.head-car').css('a').first.text    
    
    year_of_create = page.css('h3.head-car').first.text.strip.split.last[-4..-1]
    #year_of_create = 2013
    
    tiket_photo = page.xpath('//div/a/img/@src').first.value.strip!
    phone = page.css('span.phone').first.text
    adv_url = 'http://auto.ria.ua' + page.css('h3.head-car').css('a')[0]['href']
    #created_at = page.css('span.date-add')[0]['pvalue']
    created_at = page.css('span.date-add').css('span').first.text.strip!
    
    # 12:00:26 15.11.2013
    created_at = DateTime.parse(created_at, "%d.%m.%Y")
    
    #p Date.strptime("{ 2009, 4, 15 }", "{ %Y, %m, %d }")
    #created_at = Date.strptime(created_at, "%H:%i:%s %d.%m.%Y")

    # get model_id from name
    p "full_name"
    p full_name
    manufacturer_model = get_model(full_name)
    model_id = 0
    if manufacturer_model != nil
      manufacturer_model_id = manufacturer_model.id
    else
      p "cannot define model for " + id  
    end
    
    # p "url: " + adv_url
    # p "photo" + tiket_photo
    # p "name: " + full_name
    p "price: " + usd_price
    # p "phone: " + phone
    # p "created_at " + created_at.to_s
    year_of_create = Integer(year_of_create)
    p year_of_create
    
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
    p "trying to save " + id
    
    adv = Advert.new({:image_url => tiket_photo, :thumbnail_url => tiket_photo, 
    :url => adv_url, :advert_created_at => created_at,
    :advert_created_at => year_of_create, :price => usd_price, 
    :manufacturer_model_id => model_id})
      
    adv.save()
    p "saved " + id
    return page
  end
   
end