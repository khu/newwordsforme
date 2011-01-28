class Word < ActiveRecord::Base 
  validates :word, :presence => true 
  validates :translation, :presence => true
  belongs_to :user
  attr_accessor :translation
  
  def translate!
    translated = Net::HTTP.get 'ajax.googleapis.com', '/ajax/services/language/translate?v=1.0&q='+ hash[:word] + '&langpair=en|zh-CN'
    j = ActiveSupport::JSON
    encoded = j.decode(translated)
    @translation = encoded["responseData"]["translatedText"]  
  end
  
  def self.create(hash)
      Word.new(hash)
  end 
end