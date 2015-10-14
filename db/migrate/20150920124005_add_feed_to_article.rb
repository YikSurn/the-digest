class AddFeedToArticle < ActiveRecord::Migration
  def change
    add_reference :articles, :feeds, index: true, foreign_key: true
  end
end
