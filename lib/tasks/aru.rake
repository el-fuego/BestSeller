# для получения контента через http
require 'open-uri'
# подключаем Nokogiri
require 'nokogiri'
require 'tasks/get_model.rb'


namespace :aru do
  desc "grab adv from auto.ria.ua"
  
  task :grab, [:start_page, :page_count] => [:environment] do |t, args|
    args.with_defaults(:start_page => 0, :page_count => 20)
    # i dont know what "=> :environment" mean
    puts "grabber is runned"
    startPage = Integer(args.start_page)
    endPage = startPage + Integer(args.page_count)
    puts startPage
    puts endPage

    # do not parse exist adverts
    last_advert = Advert.limit(1)[0]
    if last_advert
      last_advert_date = last_advert.advert_created_at
      puts "last_advert_date #{last_advert_date}"
    end
    found_old_advert = false
    
    #getAdvHtmlBlock('11175983')
    (startPage..endPage).to_a.each do |page_id|
      if !found_old_advert
        getTopIds(page_id).each do |advert_id|
          if !found_old_advert

            begin
              advert = getAdvHtmlBlock(advert_id)
            rescue Exception
              puts 'error'
            end

            found_old_advert = advert.advert_created_at < last_advert_date if advert && last_advert_date
            puts 'stopping by last_advert_date' if found_old_advert
          end
        end
        if !found_old_advert
          puts 'sleeping..'
          sleep Random.new.rand(20.0..40.0)
        end
      end
    end

   
  end
  
  def getTopIds(page_id=0)

    puts "getting all page #{page_id} adverts.."

    url = 'http://auto.ria.ua/blocks_search_ajax/search/?bodystyle=0&countpage=100&category_id=1&view_type_id=0&page={page_id}&marka=0&model=0&s_yers=0&po_yers=0&state=0&city=0&price_ot=&price_do=&currency=1&gearbox=0&type=0&drive_type=0&door=0&color=0&metallic=0&engineVolumeFrom=&engineVolumeTo=&raceFrom=&raceTo=&powerFrom=&powerTo=&power_name=1&fuelRateFrom=&fuelRateTo=&fuelRatesType=city&custom=0&damage=0&saledParam=0&under_credit=0&confiscated_car=0&auto_repairs=0&with_exchange=0&with_real_exchange=0&exchangeTypeId=0&with_photo=0&with_video=0&is_hot=0&vip=0&checked_auto_ria=0&top=0&order_by=0&hide_black_list=0&auto_id=&auth=0&deletedAutoSearch=0&user_id=0&scroll_to_auto_id=0&expand_search=0&can_be_checked=0&last_auto_id=0&matched_country=-1&seatsFrom=&seatsTo=&wheelFormulaId=0&axleId=0&carryingTo=&carryingFrom=&search_near_states=0'
    url = url.sub! "{page_id}", page_id.to_s
    # получаем содержимое веб-страницы в объект
    jsonData = JSON.parse(open(url.to_s).read())

    puts 'done'

    jsonData['result']['search_result']['ids']
  end

  def getAdvHtmlBlock(id)
    puts ''
    puts "processing advert ##{id}.."
    
    url = 'http://auto.ria.ua/blocks_search/view/auto/{adv_id}/?lang_id=2&view_type_id=0&strategy=default&domain_zone=ua&user_id=2305539'
    url = url.sub! "{adv_id}", id
    filename = "tmp/aru_car_#{id}.html"

    if (File.exist?(filename))
      puts "reading from cache.."
      html = File.open(filename, "rb").read
    else
      html = open(url.to_s).read
      File.open(filename, 'w+'){|file| file.write(html)}
    end

    puts 'readed. parsing..'

    page = Nokogiri::HTML(html)
    begin
      usd_price = page.css('div.price').css('strong.green').first.text
    rescue Exception
      return nil
    end  

    
    usd_price = usd_price.split.join
    full_name = page.css('h3.head-car').css('a').first.text    
    year_of_create = page.css('h3.head-car').first.text.strip.split.last[-4..-1].to_i
    city = page.css('span.city').css('a').first.text.strip
    thumbnail_url = page.xpath('//div/a/img/@src').first.value.strip!
    description = page.css('ul.characteristic').first.to_s

    created_at = DateTime.parse page.css('span.date-add')[0]['pvalue']
    puts created_at


    # get model_id from name
    manufacturer_model = get_model(full_name)
    if manufacturer_model != nil
      model_id = manufacturer_model.id
    else
      puts "cannot define model for #{full_name.to_s}"
      return nil
    end
    
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
    puts "trying to save #{full_name.to_s}.."
    
    adv = Advert.new({
    :thumbnail_url => thumbnail_url, 
    :url => "http://auto.ria.ua/auto_car_#{id}.html",
    :advert_created_at => created_at,
    :price => usd_price,
    :manufacture_year => year_of_create,  
    :manufacturer_model_id => model_id,
    :city => city,
    :description => description})
      
    adv.save()
    puts "saved " + id
    adv
  end
   
end