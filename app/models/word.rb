class Word < ActiveRecord::Base 
  validates :word, :presence => true 
  validates :translation, :presence => true
  belongs_to :user
 
end