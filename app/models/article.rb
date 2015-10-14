class Article < ActiveRecord::Base
  # Articles have tags
  acts_as_taggable

  belongs_to :source
end
