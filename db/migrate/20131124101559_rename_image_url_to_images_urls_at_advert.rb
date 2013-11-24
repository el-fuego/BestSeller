class RenameImageUrlToImagesUrlsAtAdvert < ActiveRecord::Migration
  def change
    rename_column :adverts, :image_url, :images_urls
  end
end
