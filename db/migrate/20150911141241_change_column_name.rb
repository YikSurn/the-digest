class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :articles, :images, :image_url
  end
end
