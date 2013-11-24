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

  task :loadmy => :environment do
    jsonData = open("http://auto.ria.ua/ajax.php?target=auto&event=load_subcategory&marka_id=199&lang_id=2&category_id=0&is_hot=0&under_credit=0&matched_country=-1&checked_auto_ria=0&with_exchange=1").read()
    p "jsonData"
    p jsonData.decode("UTF-8")
  end

  task :load => :environment do
    manufacturers = JSON.parse  File.read("lib/tasks/auto_ria_manufacturers.json")

    manufacturers.each do |k,v|
      puts v
      #a = Manufacturer.new({:name => v})
      #a.save!

      load_models(k).each do |n|
        puts "    #{n.to_s}"

        #ManufacturerModel.new({:name => n, :manufacturer_id => a.id}).save!
      end
    end
  end


  def load_models (manufacturer_id)
    require 'open-uri'
    require 'json/pure'

    result = open("http://auto.ria.ua/ajax.php?target=auto&event=load_subcategory&marka_id=#{manufacturer_id}&lang_id=2&category_id=0&is_hot=0&under_credit=0&matched_country=-1&checked_auto_ria=0&with_exchange=1").read()

    result.force_encoding Encoding::UTF_8


    #a = '{"modelArr":[{"model_id":"2005","name":"12","is_group":"0","active":"1","parent_id":"0","count":"12"},{"model_id":"2449","name":"13","is_group":"0","active":"1","parent_id":"0","count":"2"},{"model_id":"2450","name":"14","is_group":"0","active":"1","parent_id":"0","count":"6"},{"model_id":"1825","name":"20","is_group":"0","active":"1","parent_id":"0","count":"31"},{"model_id":"1757","name":"21","is_group":"0","active":"1","parent_id":"0","count":"590"},{"model_id":"3734","name":"22","is_group":"0","active":"1","parent_id":"0","count":"15"},{"model_id":"36338","name":"2214","is_group":"0","active":"1","parent_id":"0","count":"2"},{"model_id":"936","name":"2217 \u0421\u043e\u0431\u043e\u043b\u044c","is_group":"0","active":"1","parent_id":"0","count":"57"},{"model_id":"935","name":"22171","is_group":"0","active":"1","parent_id":"0","count":"7"},{"model_id":"882","name":"24","is_group":"0","active":"1","parent_id":"0","count":"541"},{"model_id":"1761","name":"2401","is_group":"0","active":"1","parent_id":"0","count":"74"},{"model_id":"1762","name":"2402","is_group":"0","active":"1","parent_id":"0","count":"29"},{"model_id":"34323","name":"2403","is_group":"0","active":"1","parent_id":"0","count":"3"},{"model_id":"34324","name":"2404","is_group":"0","active":"1","parent_id":"0","count":"2"},{"model_id":"883","name":"2410","is_group":"0","active":"1","parent_id":"0","count":"425"},{"model_id":"30490","name":"2411","is_group":"0","active":"1","parent_id":"0","count":"22"},{"model_id":"1763","name":"2412","is_group":"0","active":"1","parent_id":"0","count":"12"},{"model_id":"2982","name":"2413","is_group":"0","active":"1","parent_id":"0","count":"1"},{"model_id":"31962","name":"2417","is_group":"0","active":"1","parent_id":"0","count":"10"},{"model_id":"38047","name":"2704","is_group":"0","active":"1","parent_id":"0","count":"2"},{"model_id":"932","name":"2705 \u0413\u0430\u0437\u0435\u043b\u044c","is_group":"0","active":"1","parent_id":"0","count":"997"},{"model_id":"31646","name":"2747","is_group":"0","active":"1","parent_id":"0","count":"5"},{"model_id":"934","name":"2752 \u0421\u043e\u0431\u043e\u043b\u044c","is_group":"0","active":"1","parent_id":"0","count":"306"},{"model_id":"34779","name":"2753 \u0421\u043e\u0431\u043e\u043b\u044c","is_group":"0","active":"1","parent_id":"0","count":"52"},{"model_id":"41977","name":"2757","is_group":"0","active":"1","parent_id":"0","count":"1"},{"model_id":"2632","name":"31010","is_group":"0","active":"1","parent_id":"0","count":"13"},{"model_id":"884","name":"3102","is_group":"0","active":"1","parent_id":"0","count":"63"},{"model_id":"938","name":"31022","is_group":"0","active":"1","parent_id":"0","count":"4"},{"model_id":"885","name":"310221","is_group":"0","active":"1","parent_id":"0","count":"5"},{"model_id":"886","name":"31029","is_group":"0","active":"1","parent_id":"0","count":"306"},{"model_id":"39330","name":"3105","is_group":"0","active":"1","parent_id":"0","count":"6"},{"model_id":"887","name":"3110","is_group":"0","active":"1","parent_id":"0","count":"615"},{"model_id":"31815","name":"31104","is_group":"0","active":"1","parent_id":"0","count":"1"},{"model_id":"937","name":"31105","is_group":"0","active":"1","parent_id":"0","count":"374"},{"model_id":"888","name":"3111","is_group":"0","active":"1","parent_id":"0","count":"1"},{"model_id":"33402","name":"3202 \u0413\u0430\u0437\u0435\u043b\u044c","is_group":"0","active":"1","parent_id":"0","count":"253"},{"model_id":"34720","name":"3212","is_group":"0","active":"1","parent_id":"0","count":"9"},{"model_id":"930","name":"3221 \u0413\u0430\u0437\u0435\u043b\u044c","is_group":"0","active":"1","parent_id":"0","count":"26"},{"model_id":"29424","name":"32212","is_group":"0","active":"1","parent_id":"0","count":"15"},{"model_id":"32903","name":"32213","is_group":"0","active":"1","parent_id":"0","count":"81"},{"model_id":"15721","name":"32213 \u0413\u0430\u0437\u0435\u043b\u044c","is_group":"0","active":"1","parent_id":"0","count":"272"},{"model_id":"15722","name":"322132","is_group":"0","active":"1","parent_id":"0","count":"56"},{"model_id":"38048","name":"32214","is_group":"0","active":"1","parent_id":"0","count":"31"},{"model_id":"15725","name":"322173","is_group":"0","active":"1","parent_id":"0","count":"3"},{"model_id":"37212","name":"3270","is_group":"0","active":"1","parent_id":"0","count":"1"},{"model_id":"28240","name":"3274","is_group":"0","active":"1","parent_id":"0","count":"2"},{"model_id":"36335","name":"3301","is_group":"0","active":"1","parent_id":"0","count":"2"},{"model_id":"39121","name":"3302","is_group":"0","active":"1","parent_id":"0","count":"14"},{"model_id":"929","name":"3302 \u0413\u0430\u0437\u0435\u043b\u044c","is_group":"0","active":"1","parent_id":"0","count":"1185"},{"model_id":"32650","name":"33021","is_group":"0","active":"1","parent_id":"0","count":"318"},{"model_id":"34502","name":"33021 \u0413\u0430\u0437\u0435\u043b\u044c","is_group":"0","active":"1","parent_id":"0","count":"101"},{"model_id":"31647","name":"33023 \u0413\u0430\u0437\u0435\u043b\u044c","is_group":"0","active":"1","parent_id":"0","count":"356"},{"model_id":"39501","name":"33029","is_group":"0","active":"1","parent_id":"0","count":"4"},{"model_id":"34316","name":"3304","is_group":"0","active":"1","parent_id":"0","count":"1"},{"model_id":"41710","name":"3305","is_group":"0","active":"1","parent_id":"0","count":"1"},{"model_id":"2829","name":"3306","is_group":"0","active":"1","parent_id":"0","count":"6"},{"model_id":"1894","name":"3307","is_group":"0","active":"1","parent_id":"0","count":"318"},{"model_id":"28239","name":"3308","is_group":"0","active":"1","parent_id":"0","count":"2"},{"model_id":"1767","name":"3309","is_group":"0","active":"1","parent_id":"0","count":"73"},{"model_id":"29708","name":"3310 \u0412\u0430\u043b\u0434\u0430\u0439","is_group":"0","active":"1","parent_id":"0","count":"68"},{"model_id":"2649","name":"3321","is_group":"0","active":"1","parent_id":"0","count":"18"},{"model_id":"3394","name":"3507","is_group":"0","active":"1","parent_id":"0","count":"52"},{"model_id":"40222","name":"3508","is_group":"0","active":"1","parent_id":"0","count":"5"},{"model_id":"38049","name":"3512","is_group":"0","active":"1","parent_id":"0","count":"1"},{"model_id":"2960","name":"4301","is_group":"0","active":"1","parent_id":"0","count":"51"},{"model_id":"31981","name":"4509","is_group":"0","active":"1","parent_id":"0","count":"10"},{"model_id":"1768","name":"51","is_group":"0","active":"1","parent_id":"0","count":"24"},{"model_id":"28951","name":"52","is_group":"0","active":"1","parent_id":"0","count":"110"},{"model_id":"2642","name":"5201","is_group":"0","active":"1","parent_id":"0","count":"25"},{"model_id":"40492","name":"5203","is_group":"0","active":"1","parent_id":"0","count":"2"},{"model_id":"34780","name":"5205","is_group":"0","active":"1","parent_id":"0","count":"2"},{"model_id":"33856","name":"5227","is_group":"0","active":"1","parent_id":"0","count":"3"},{"model_id":"34685","name":"5228","is_group":"0","active":"1","parent_id":"0","count":"2"},{"model_id":"38284","name":"53","is_group":"0","active":"1","parent_id":"0","count":"76"},{"model_id":"1772","name":"53 \u0433\u0440\u0443\u0437.","is_group":"0","active":"1","parent_id":"0","count":"401"},{"model_id":"36649","name":"5301","is_group":"0","active":"1","parent_id":"0","count":"15"},{"model_id":"40493","name":"5302","is_group":"0","active":"1","parent_id":"0","count":"4"},{"model_id":"28502","name":"5312","is_group":"0","active":"1","parent_id":"0","count":"60"},{"model_id":"41528","name":"5314","is_group":"0","active":"1","parent_id":"0","count":"1"},{"model_id":"33535","name":"5319","is_group":"0","active":"1","parent_id":"0","count":"1"},{"model_id":"35552","name":"531900","is_group":"0","active":"1","parent_id":"0","count":"2"},{"model_id":"30755","name":"5327","is_group":"0","active":"1","parent_id":"0","count":"18"},{"model_id":"31903","name":"63","is_group":"0","active":"1","parent_id":"0","count":"14"},{"model_id":"1769","name":"66","is_group":"0","active":"1","parent_id":"0","count":"124"},{"model_id":"39537","name":"6605","is_group":"0","active":"1","parent_id":"0","count":"1"},{"model_id":"2501","name":"67","is_group":"0","active":"1","parent_id":"0","count":"10"},{"model_id":"1770","name":"69","is_group":"0","active":"1","parent_id":"0","count":"200"},{"model_id":"30966","name":"704","is_group":"0","active":"1","parent_id":"0","count":"10"},{"model_id":"41416","name":"73","is_group":"0","active":"1","parent_id":"0","count":"1"},{"model_id":"36022","name":"93","is_group":"0","active":"1","parent_id":"0","count":"2"},{"model_id":"41990","name":"AA","is_group":"0","active":"1","parent_id":"0","count":"1"},{"model_id":"35119","name":"M21","is_group":"0","active":"1","parent_id":"0","count":"10"},{"model_id":"41741","name":"Next","is_group":"0","active":"1","parent_id":"0","count":"3"},{"model_id":"38868","name":"\u0410\u041d\u041c-3307","is_group":"0","active":"1","parent_id":"0","count":"8"},{"model_id":"31978","name":"\u0410\u041d\u041c-53","is_group":"0","active":"1","parent_id":"0","count":"7"},{"model_id":"40463","name":"\u041c 21","is_group":"0","active":"1","parent_id":"0","count":"7"},{"model_id":"29756","name":"\u041c20","is_group":"0","active":"1","parent_id":"0","count":"73"},{"model_id":"3805","name":"\u0420\u0423\u0422\u0410","is_group":"0","active":"1","parent_id":"0","count":"11"},{"model_id":"29242","name":"\u0421\u043e\u0431\u043e\u043b\u044c","is_group":"0","active":"1","parent_id":"0","count":"77"}],"markaId":91,"sourceId":null,"targetId":null,"zone":null}'
    #
    #puts a.encoding
    #puts JSON.parse(a)["modelArr"].map{|m|m['name']}.join ', '

    hash = JSON.parse result

    hash["modelArr"].map{|m|m['name']}
  end

end