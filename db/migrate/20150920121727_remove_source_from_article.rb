class RemoveSourceFromArticle < ActiveRecord::Migration
  def change
    remove_column :articles, :source, :string
  end
end
