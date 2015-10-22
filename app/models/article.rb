class Article < ActiveRecord::Base
  # Articles have tags
  acts_as_taggable

  belongs_to :source
  has_and_belongs_to_many :user

  # Articles per page
  self.per_page = 10
end
