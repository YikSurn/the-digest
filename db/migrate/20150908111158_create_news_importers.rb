class CreateNewsImporters < ActiveRecord::Migration
  def change
    create_table :news_importers do |t|
      t.string :name
      t.string :url

      t.timestamps null: false
    end
  end
end
