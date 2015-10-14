class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.datetime :pub_date
      t.string :summary
      t.string :author
      t.string :image_url
      t.string :url
      t.string :guid

      t.timestamps null: false
    end
  end
end
