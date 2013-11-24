# encoding: utf-8
class Advert < ActiveRecord::Base
  belongs_to :manufacturer_model
  has_one :best_offer
  belongs_to :manufacturer



  # ----------------------------
  # SERIALIZED DATA
  # ----------------------------


  class Serializer < Array
    def serializeStringArray(data)
      a = data.gsub(/\\"/, '"')
      .gsub(/(",\s+)?:([a-z_0-9]+)=>"/i, '\t')
      .gsub(/"?\}/, '\n')
      .gsub(/(^[\\t\\n\\s\[\{]+|[\]\\n\\t\\s]+$)/, '')
      puts a
      a
    end
  end

  class ImagesList < Serializer
    def load(db_value)
      return [] if !db_value
      db_value.split('\n')
    end
    def dump(data)
      return serializeStringArray(data) if data.class == String # hack for ActiveAdmin :(
      data.join '\n'
    end
  end

  serialize :images_urls, ImagesList.new




  # ----------------------------
  # VALIDATIONS
  # ----------------------------

  validates :manufacturer_model_id,
            :numericality => {
                :only_integer => true
            },
            :presence => true

  validates :price,
            :numericality => {
                :only_integer => true
            },
            :presence => true

  validates :manufacture_year,
            :numericality => {
                :only_integer => true
            },
            :presence => true

  validates :thumbnail_url,
            :presence => true

  validates :url,
            :uniqueness => true,
            :presence => true

end
