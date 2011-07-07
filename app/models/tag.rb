class Tag < ActiveRecord::Base
  has_many :word_tag_relations
  has_many :words, :through => :word_tag_relations
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
