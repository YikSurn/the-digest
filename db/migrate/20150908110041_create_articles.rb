class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :source
      t.string :title
      t.date :pubDate
      t.string :summary
      t.string :author
      t.string :images
      t.string :url
      t.string :comments
      t.string :categories

      t.timestamps null: false
    end
  end
end
