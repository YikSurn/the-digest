class RemoveCategoriesFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :categories, :string
  end
end
