# для получения контента через http
require 'open-uri'
# подключаем Nokogiri
require 'nokogiri'
require 'tasks/get_model.rb'


namespace :aru do
  desc "grab adverts from auto.ria.ua"

  task :clear => :environment do
    Advert.delete_all
  end
  
  task :parse, [:start_page, :end_page] => [:environment] do |t, args|
    args.with_defaults(start_page: 0)
    start_page = args.start_page.to_i
    end_page =   args.end_page == nil ? load_adverts_pages_count : args.end_page.to_i

    if start_page > end_page
      puts "Not found adverts. Last page is #{end_page}".colorize :red
      return
    end

    puts "grabing from #{start_page} to #{end_page}".colorize :green

    (start_page..end_page).to_a.each do |page_id|
      ids = load_adverts_ids(page_id)
      adverts_is_saved = Parallel.map(ids, in_theads: 20) do |advert_id|
        save_advert load_advert(advert_id), advert_id
      end
      puts "#{adverts_is_saved.delete_if{|a|a == false}.length}/#{ids.length} adverts saved at page #{page_id}".colorize :green
      puts 'sleeping..'
      sleep Random.new.rand(20.0..40.0)
    end
  end

  def getSearchUrl(page_id=0, period_code=5)

    # period_code:
    #  0 все
    #  1 за час
    #  8 за 3 часа
    #  9 за 6 часов
    #  2 за сегодня
    # 11 за сутки
    # 10 за 2 дня
    #  3 за 3 дня
    #  4 за неделю
    #  5 за месяц
    #  6 за 3 месяца
    "http://auto.ria.ua/blocks_search_ajax/search/?bodystyle=0&countpage=100&category_id=1&view_type_id=0&page=#{page_id}&marka=0&model=0&s_yers=0&po_yers=0&state=0&city=0&price_ot=&price_do=&currency=1&gearbox=0&type=0&drive_type=0&door=0&color=0&metallic=0&engineVolumeFrom=&engineVolumeTo=&raceFrom=&raceTo=&powerFrom=&powerTo=&power_name=1&fuelRateFrom=&fuelRateTo=&fuelRatesType=city&custom=0&damage=0&saledParam=0&under_credit=0&confiscated_car=0&auto_repairs=0&with_exchange=0&with_real_exchange=0&exchangeTypeId=0&with_photo=0&with_video=0&is_hot=0&vip=0&checked_auto_ria=0&top=#{period_code}&order_by=0&hide_black_list=0&auto_id=&auth=0&deletedAutoSearch=0&user_id=0&scroll_to_auto_id=0&expand_search=0&can_be_checked=0&last_auto_id=0&matched_country=-1&seatsFrom=&seatsTo=&wheelFormulaId=0&axleId=0&carryingTo=&carryingFrom=&search_near_states=0"
  end


  ##############################
  # load advert ids as search request to site
  def load_adverts_ids(page_id=0)

    puts ''
    puts "getting adverts at page #{page_id} .."

    # get page data as JSON
    jsonData = JSON.parse open(getSearchUrl(page_id)).read()
    puts 'done'

    jsonData['result']['search_result']['ids']
  end


  ##############################
  # load advert ids as search request to site
  def load_adverts_pages_count

    puts ''
    puts "getting pages count.."

    # get page data as JSON
    jsonData = JSON.parse open(getSearchUrl).read()
    puts 'done'

    (jsonData['result']['search_result']['count'] / jsonData['result']['additional']['search_params']['all']['countpage']).ceil
  end

  ##############################
  # load advert page
  def load_advert(id)
    #puts ''
    #puts "processing advert ##{id}.."

    url = "http://auto.ria.ua/blocks_search/view/auto/#{id}/?lang_id=2&view_type_id=0&strategy=default&domain_zone=ua&user_id=2305539"
    filename = "tmp/aru_car_#{id}.html"

    if (File.exist?(filename))
      # puts "reading from cache.."
      html = File.open(filename, "rb").read
    else
      html = open(url.to_s).read
      File.open(filename, 'w+'){|file| file.write(html)}
    end

    Nokogiri::HTML(html)
  end

  ##############################
  # parse & save advert data
  def save_advert(document, id)

    _url = "http://auto.ria.ua/blocks_search/view/auto/#{id}/?lang_id=2&view_type_id=0&strategy=default&domain_zone=ua&user_id=2305539"

    # check for parsing errors
    el = {
        thumbnail_url:         document.css('div a img[src]'),
        name:                  document.css('h3.head-car a'),
        url:                   document.css('h3.head-car a'),
        advert_created_at:     document.css('span.date-add'),
        price:                 document.css('div.price strong.green'),
        manufacture_year:      document.css('h3.head-car'),
        city:                  document.css('span.city a'),
        description:           document.css('ul.characteristic, .descriptions-ticket')
    }
    has_parse_error = false
    el.each do |k, v|
      if v == nil || v.length == 0
        puts "error while parsing #{k.to_s.colorize :red} at #{_url}"
        has_parse_error = true
      end
    end
    return false if has_parse_error

    # get model_id from name
    name = el[:name].first.text.strip
    manufacturer_model = get_model(name)
    if manufacturer_model != nil
      model_id = manufacturer_model.id
    else
      puts "cannot #{'define model'.colorize :red} for #{name.to_s} at #{_url}"
      return false
    end

    # prepare and save model data
    adv = Advert.new({
      thumbnail_url:         el[:thumbnail_url].first.attr('src').strip.gsub(/[a-z]+\.jpg$/, 'bx.jpg'),
      is_cleared:            document.css('.nocleared').length == 0,
      url:                   'http://auto.ria.ua' + el[:url].first.attr('href').strip, #"http://auto.ria.ua/auto_car_#{id}.html",
      advert_created_at:     DateTime.parse(el[:advert_created_at].first.attr('pvalue')),
      price:                 el[:price].first.text.gsub(/[^0-9]+/, '').to_i,
      manufacture_year:      el[:manufacture_year].first.text.strip.split.last[-4..-1].to_i,
      manufacturer_model_id: model_id,
      city:                  el[:city].first.text.strip,
      description:           el[:description].to_s
    })


    if adv.save
      puts "#{name} saved"
      return true
    else
      puts "#{name} cant be saved: #{adv.errors.messages.to_s}".colorize :red
      return false
    end
  end
end