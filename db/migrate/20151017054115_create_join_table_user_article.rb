class CreateJoinTableUserArticle < ActiveRecord::Migration
  def change
    create_join_table :Users, :Articles do |t|
      # t.index [:user_id, :article_id]
      # t.index [:article_id, :user_id]
    end
  end
end
