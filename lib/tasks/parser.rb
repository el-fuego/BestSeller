task :parse_site do
  puts "tro-lo-lo."



end

# TODO Remove after tests
task :get_model, [:name] => :environment do |task, args|
  puts get_model args.name
end

def get_model (good_name)
  manufacturers = Manufacturer.all
  models = ManufacturerModel.all
  found_manufacturers = []
  found_models = []

  # try to find all manufacturers and models by each word
  words = good_name.split ' '
  words.each do |word|
    word.capitalize!
    found_manufacturers = found_manufacturers + manufacturers.select{|mf| mf.name == word}
    found_models = found_models + models.select{|m| m.name == word}
  end

  # nothing found
  return if found_manufacturers.empty? || found_models.empty?

  # one model found
  return found_models.first if found_models.length == 1

  # many models
  # search for associated with found manufacturers
  found_models.select{|m| found_manufacturers.find{|mf| mf.id == m.manufacturer_id}}.first
end