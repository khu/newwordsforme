class Tag < ActiveRecord::Base
  has_many :word_tag_relations
  has_many :words, :through => :word_tag_relations
  
  validates_uniqueness_of :name
  validates :name,  :presence => true, :length   => { :maximum => 20 }
end
