class WordTagRelation < ActiveRecord::Base
  belongs_to :word
  belongs_to :tag
end
