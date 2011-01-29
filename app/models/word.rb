class Word < ActiveRecord::Base 
  validates :word, :presence => true 
  validates :translation, :presence => true
  belongs_to :user
  
  def translate!
    translated = Net::HTTP.get 'ajax.googleapis.com', '/ajax/services/language/translate?v=1.0&q='+ word + '&langpair=en|zh-CN'
    j = ActiveSupport::JSON
    encoded = j.decode(translated)
    self.translation = encoded["responseData"]["translatedText"]  
  end
  
  def self.create(hash)
      word = Word.new(hash)
      return word
  end 
end