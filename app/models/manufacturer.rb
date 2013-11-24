class Manufacturer < ActiveRecord::Base
  has_many :adverts, :through => :manufacturer_models

  before_save :remove_symbols

  def remove_symbols
    self.name.gsub! /[\sa-zA-Z0-9\-_а-яА-Я’єЄїЇіІґҐ()]+/, ''
  end
end
