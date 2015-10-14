class DropNewsImportersTable < ActiveRecord::Migration
  def change
    drop_table :news_importers
  end
end
