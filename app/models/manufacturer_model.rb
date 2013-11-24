# encoding: utf-8
class ManufacturerModel < ActiveRecord::Base
  belongs_to :manufacturer
  has_many :adverts

  before_save :remove_symbols

  def remove_symbols
    self.name.gsub! /[^\sa-zA-Z0-9\-_а-яА-Я’єЄїЇіІґҐ()]+/, ''
  end
end
