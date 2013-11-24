# encoding: utf-8
require 'rubygems'

def get_model (good_name)
  found_models = _find_models_by_pattern good_name, ManufacturerModel.all

  # nothing found
  return if found_models.empty?

  # one model found
  return found_models.first if found_models.length == 1

  found_manufacturers = _find_models_by_pattern good_name, Manufacturer.all

  # many models
  # search for associated with found manufacturers
  found_models.select{|m| found_manufacturers.find{|mf| mf.id == m.manufacturer_id}}.first
end

def _find_models_by_pattern(good_name, models)
  models_patterns = models.map{|m|{model:m, pattern: Regexp.new("(^|[\\s\\.,])#{m.name}($|[\\s\\.,])", true)}}
  found_models = []

  # try to find all models
  models_patterns.each do |model_pattern|
    found_models << model_pattern[:model] if good_name =~ model_pattern[:pattern]
  end

  found_models
end