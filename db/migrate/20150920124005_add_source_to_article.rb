class AddSourceToArticle < ActiveRecord::Migration
  def change
    add_reference :articles, :sources, index: true, foreign_key: true
  end
end
