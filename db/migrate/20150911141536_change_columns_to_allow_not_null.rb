class ChangeColumnsToAllowNotNull < ActiveRecord::Migration
  def change
    change_column :articles, :title, :string, :null => false
    change_column :articles, :pub_date, :datetime, :null => false
    change_column :articles, :summary, :string, :null => false
    change_column :articles, :url, :string, :null => false

    change_column :sources, :name, :string, :null => false
    change_column :sources, :url, :string, :null => false

    change_column :users, :first_name, :string, :null => false
    change_column :users, :last_name, :string, :null => false
    change_column :users, :email, :string, :null => false
    change_column :users, :username, :string, :null => false
    change_column :users, :password_digest, :string, :null => false
  end
end
