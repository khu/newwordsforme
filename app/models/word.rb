class Word < ActiveRecord::Base 
  validates :word, :presence => true 
  validates :translation, :presence => true
  belongs_to :user

  def self.translate(hash)
      translated = Net::HTTP.get 'ajax.googleapis.com', '/ajax/services/language/translate?v=1.0&q='+ hash[:word] + '&langpair=en|zh-CN'
      j = ActiveSupport::JSON
      encoded = j.decode(translated)
      hash[:translation] = encoded["responseData"]["translatedText"]
      Word.new(hash)
  end 
end